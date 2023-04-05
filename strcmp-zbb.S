/* Copyright (c) 2023  SiFive Inc. All rights reserved.
   This copyrighted material is made available to anyone wishing to use,
   modify, copy, or redistribute it subject to the terms and conditions
   of the FreeBSD License.   This program is distributed in the hope that
   it will be useful, but WITHOUT ANY WARRANTY expressed or implied,
   including the implied warranties of MERCHANTABILITY or FITNESS FOR
   A PARTICULAR PURPOSE.  A copy of this license is available at
   http://www.opensource.org/licenses.
*/

#include <sys/asm.h>

#if BYTE_ORDER != LITTLE_ENDIAN
# error
#endif

#ifndef __riscv_zbb
#error "Must compile with zbb"
#endif

#if __riscv_xlen == 64
  #define N 3
#else
  #define N 5
#endif

.text
.globl strcmp
.type  strcmp, @function
.align 2
strcmp:
  or    a4, a0, a1
  li    t2, -1
  and   a4, a4, SZREG-1
  beqz  a4, .Lenter
  j .Lmisaligned

  .macro check_one_word i n
    REG_L a2, \i*SZREG(a0)
    REG_L a3, \i*SZREG(a1)

    orc.b t0, a2

    bne   t0, t2, .Lnull\i
    .if \i+1-\n
      bne   a2, a3, .Lmismatch
    .else
      beq   a2, a3, .Lloop
      # fall through to .Lmismatch
    .endif
  .endm

  .macro foundnull i n
    .ifne \i
      .Lnull\i:
      add   a0, a0, \i*SZREG
      add   a1, a1, \i*SZREG
      .ifeq \i-1
        .Lnull0:
      .endif
      bne   a2, a3, .Lmisaligned
      li    a0, 0
      ret
    .endif
  .endm

.Lloop:
  add   a0, a0, N*SZREG
  add   a1, a1, N*SZREG

.Lenter:
  # examine full words at a time, favoring strings of a couple dozen chars
#if __riscv_xlen == 32
  check_one_word 0 N
  check_one_word 1 N
  check_one_word 2 N
  check_one_word 3 N
  check_one_word 4 N
#else
  check_one_word 0 N
  check_one_word 1 N
  check_one_word 2 N
#endif
  # backwards branch to .Lloop contained above

.Lmismatch:
  rev8 a4, a2
  rev8 a5, a3
  bgeu a4, a5, 1f
  li a0, -1
  ret
1:
  li a0, 1
  ret

.Lmisaligned:
  # misaligned
  lbu   a2, 0(a0)
  lbu   a3, 0(a1)
  add   a0, a0, 1
  add   a1, a1, 1
  bne   a2, a3, 1f
  bnez  a2, .Lmisaligned

1:
  sub   a0, a2, a3
  ret

  # cases in which a null byte was detected
#if __riscv_xlen == 32
  foundnull 0 5
  foundnull 1 5
  foundnull 2 5
  foundnull 3 5
  foundnull 4 5
#else
  foundnull 0 3
  foundnull 1 3
  foundnull 2 3
#endif
.size	strcmp, .-strcmp
        

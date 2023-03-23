#include <machine/syscall.h>
#include <sys/time.h>
#include "internal_syscall.h"

#include <stdint.h>
#include <inttypes.h>

uint64_t rdcycle (void) {
    uint64_t retval;
    __asm__ volatile (
        "fence\n"
        "rdcycle %0"
        : "=r"(retval) );
    return retval;
}

uint64_t rdinstret (void) {
    uint64_t retval;
    __asm__ volatile (
        "fence\n"
        "csrr %0,instret"
        : "=r"(retval) );
    return retval;
}

/* Get the current time.  Only relatively correct.  */
int
_gettimeofday(struct timeval *tp, void *tzp)
{
  static int times = 0;
  uint64_t cycles[3];
  uint64_t instret[3];
  uint64_t usec[3];
  int ret;
  ret = syscall_errno (SYS_gettimeofday, tp, 0, 0, 0, 0, 0);
  if (times < 3) {
      cycles[times] = rdcycle();
      instret[times] = rdinstret();
      usec[times] = tp->tv_sec * 1000000 + tp->tv_usec;
  }
  ++times;
  if (times == 3) {
      printf("cycles=%"PRIu64" instret=%"PRIu64" usec=%"PRIu64"\n",
          cycles[2] - cycles[1], instret[2] - instret[1], usec[2] - usec[1]);
  }

  return ret;
}


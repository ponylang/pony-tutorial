#include <stdint.h>

// A fast, minimal memory, consistent hash algorithm
// https://arxiv.org/abs/1406.2294
int32_t jch_chash(uint64_t key, uint32_t num_buckets)
{
  int b = -1;
  uint64_t j = 0;

  do {
    b = j;
    key = key * 2862933555777941757ULL + 1;
    j = (b + 1) * ((double)(1LL << 31) / ((double)(key >> 33) + 1));
  } while(j < num_buckets);

  return (int32_t)b;
}
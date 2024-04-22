// custser.c

#include <stdlib.h>
#include <string.h>

extern char *get_string()
{
  return "hello world\n";
}

extern size_t serialise_space(char *s)
{
  // space for the size and the string (without the null)
  return 4 + strlen(s);
}

extern void serialise(char *buff, char *s)
{
  size_t sz = strlen(s);
  unsigned char *ubuff = (unsigned char *) buff;
  // write the size as a 32-bit big-endian integer
  ubuff[0] = (sz >> 24) & 0xFF;
  ubuff[1] = (sz >> 16) & 0xFF;
  ubuff[2] = (sz >> 8) & 0xFF;
  ubuff[3] = sz & 0xFF;

  // copy the string
  strncpy(buff + 4, s, sz);
}

extern char *deserialise(char *buff)
{
  unsigned char *ubuff = (unsigned char *) buff;
  size_t sz = (ubuff[0] << 24) + (ubuff[1] << 16) + (ubuff[2] << 8) + ubuff[3];
  char *s = malloc(sizeof(char) * sz + 1);
  memcpy(s, buff + 4, sz);
  s[sz] = '\0';
  return s;
}
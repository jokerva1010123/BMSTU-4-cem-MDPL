; А.Крупник "Изучаем Ассемблер" листинг 4.3
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\user32.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE      equ 15
.data
ifmt     db      "%d",0
buf      db BSIZE dup(?)
crlf     db 0dh,0ah
stdout   dd ?
cWritten dd ?
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax    
mov edx,1
mov ecx,10
nxt:
push    ecx
push    edx
invoke  wsprintf, ADDR buf, ADDR ifmt,edx
invoke  WriteConsoleA, stdout, ADDR buf,\
	BSIZE, ADDR cWritten, NULL
invoke  WriteConsoleA, stdout, ADDR crlf,\
	2, ADDR cWritten, NULL
pop     edx
inc     edx
pop     ecx
loop    nxt
invoke  ExitProcess, 0
end start

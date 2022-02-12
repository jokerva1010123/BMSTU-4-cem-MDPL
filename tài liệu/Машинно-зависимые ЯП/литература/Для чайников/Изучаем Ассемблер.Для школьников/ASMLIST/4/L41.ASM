; А.Крупник "Изучаем Ассемблер" листинг 4.1
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\user32.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE	equ 15
.data
ifmt		db "%d",0
buf		db BSIZE dup(?)
dig		dd 123456
stdout		dd ?
cWritten	dd ?
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax 
invoke  wsprintf, ADDR buf, ADDR ifmt, dig
invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  ExitProcess, 0
end start

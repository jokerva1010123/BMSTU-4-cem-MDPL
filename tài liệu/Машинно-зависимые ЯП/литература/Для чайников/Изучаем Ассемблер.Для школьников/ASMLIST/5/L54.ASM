; А.Крупник "Изучаем Ассемблер" листинг 5.4
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE      equ 128
.data
buf             db BSIZE dup(?)
stdout          dd ?
stdin           dd ?
cRead           dd ?
cWritten        dd ?
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov  stdout, eax 
invoke  GetStdHandle, STD_INPUT_HANDLE
mov  stdin, eax
NewLine:
invoke  ReadConsole, stdin, ADDR buf,\
        BSIZE, ADDR cRead, NULL
invoke  WriteConsoleA, stdout, ADDR buf,\
        cRead, ADDR cWritten, NULL
cmp     cRead,2
jnz     NewLine
invoke  ExitProcess, 0
end start

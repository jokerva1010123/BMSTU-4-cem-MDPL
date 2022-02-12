; А.Крупник "Изучаем Ассемблер" листинг 4.4
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\user32.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE equ 15
.data
ifmt     db "%d",00
stdout   dd ?
cWritten dd ?
.data?   
buf      db  BSIZE dup(?)
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax    
mov eax,100 
mov edx,0   ;edx:eax - делимое
mov ebx,3   ;ebx - делитель
div ebx     ;eax - частное, edx - остаток 
invoke  wsprintf, ADDR buf, ADDR ifmt,eax
invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  ExitProcess, 0
end start

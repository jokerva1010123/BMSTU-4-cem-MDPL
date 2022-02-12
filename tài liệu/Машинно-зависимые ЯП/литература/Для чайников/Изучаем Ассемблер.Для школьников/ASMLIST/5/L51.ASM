; А.Крупник "Изучаем Ассемблер" листинг 5.1
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
.data
z         db "Четное",13,10
nz        db "Нечетное",13,10
stdout    dd ?
cWritten  dd ?
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax 
mov ah, 37
and ah, 00000001b   ;выделяем младший бит
cmp ah, 0           ;четно?
jz  evn             ;да - идем к evn
invoke  WriteConsoleA, stdout, ADDR nz, \
        sizeof nz, ADDR cWritten, NULL
jmp  exit
evn:
invoke  WriteConsoleA, stdout, ADDR z,\
        sizeof z, ADDR cWritten, NULL
exit:
invoke  ExitProcess, 0
end start

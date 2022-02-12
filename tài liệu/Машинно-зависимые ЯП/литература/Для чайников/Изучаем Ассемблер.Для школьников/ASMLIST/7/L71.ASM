; А.Крупник "Изучаем Ассемблер" листинг 7.1
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
include    \myasm\include\fpu.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
includelib \myasm\lib\fpu.lib
BSIZE     equ  30
.data
sqroot    dt  ?
digit     dd  17
stdout    dd  ?
cWritten  dd  ?
buf       db BSIZE dup (?)
.code
start:
main proc
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
fild digit      ;загружаем целое в регистр
fsqrt           ;вычисляем корень
fstp sqroot     ;сохраняем в 80-ти битах
invoke  FpuFLtoA, ADDR sqroot, 10, \
        ADDR buf, SRC1_REAL or SRC2_DIMM
invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  ExitProcess, 0
main endp
end start

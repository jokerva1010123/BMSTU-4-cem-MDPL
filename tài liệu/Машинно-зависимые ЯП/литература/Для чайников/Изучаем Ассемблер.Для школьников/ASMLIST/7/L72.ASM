; А.Крупник "Изучаем Ассемблер" листинг 7.2
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
include    \myasm\include\fpu.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
includelib \myasm\lib\fpu.lib
BSIZE       equ 30
.data
alpha       dd  0.5
beta        dd  1.37
gamma       dd  220.0
delta       dd  0.65
stdout      dd  ?
cWritten    dd  ?
buf         db  BSIZE dup (?)
.code
start:
main proc
finit
fld alpha
fld beta
fmul
fld gamma
fld delta
fmul
fsub
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke  FpuFLtoA, 0, 10, ADDR buf,
        SRC1_FPU or SRC2_DIMM
Invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  ExitProcess, 0
main endp
end start

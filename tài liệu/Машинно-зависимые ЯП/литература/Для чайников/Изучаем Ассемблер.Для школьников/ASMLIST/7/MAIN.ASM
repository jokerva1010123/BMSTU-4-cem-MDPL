; А.Крупник "Изучаем Ассемблер" 
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
include    \myasm\include\fpu.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
includelib \myasm\lib\fpu.lib
Simpson    PROTO :DWORD, :DWORD, :DWORD,\ 
                 :QWORD, :DWORD
Fun        PROTO
N     equ    5
BSIZE equ    30
.data
buf          db BSIZE dup (?)
cWritten     dd ?
stdout       dd ?
iini         dd 0
iend         dd ?
n            dd N 
two          dq 2.0
four         dq 4.0
step         dq ?
sum          dt ?
.code
start:
main proc
finit
fldpi           ;загрузить p
fld   four      ;ST = 4.0
fdiv            ;ST = p/4
fst   iend      ;сохранить iend
fld   iini      ;ST = iini
fsub            ;ST = iend - iini
fild n          ;ST = n
fld two	        ;ST = 2.0
fmul            ;2 * n
fdiv            ;(iend - iini)/(2 * n)
fstp  step      ;сохранить шаг
invoke  Simpson, iini, iend, n, step,\
        ADDR sum
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke  FpuFLtoA, ADDR sum, 10, \
        ADDR buf, SRC1_REAL or SRC2_DIMM
invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  ExitProcess, 0
main    endp
Fun proc
fcos
ret
Fun endp
end start

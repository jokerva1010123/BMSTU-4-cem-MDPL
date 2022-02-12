; А.Крупник "Изучаем Ассемблер" листинг 7.3
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
include    \myasm\include\fpu.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
includelib \myasm\lib\fpu.lib
BSIZE       equ     30
.data
p           dd      -6.0
q           dd       5.0
two         dd      -2.0
root1       dt       ?
root2       dt       ?
stdout      dd       ?
cWritten    dd       ?
buf         db       BSIZE dup (?)
.code
start:
finit
fld p     ;ST=p
fld  two  ;ST = -2, ST(1) = p
fdiv      ;ST(1) = p/2 и pop
fld ST    ;ST(0) = ST(1) = p/2
fmul      ;ST(1) = ST(1)*ST(0) = p2/4 и pop
fld q     ;ST(0) = q
fsub      ;ST(0) = (p2/4) - q
fsqrt     ;Ц((p2/4) - q))
fld p     ;ST(0) = p
fld two   ;-2.0
fdiv      ;ST(0) = -p/2
fld  ST   ;ST(1) = ST(0)
fsub ST,ST(2)   ;ST = -p/2 - Ц((p2/4) - q))
fstp root1      ;сохранить корень
fadd ST,ST(1)   ;ST = -p/2 + Ц((p2/4) - q))
fstp root2      ;сохранить корень
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov  stdout, eax
invoke  FpuFLtoA, ADDR root1, 10, \
        ADDR buf, SRC1_REAL or SRC2_DIMM
invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  FpuFLtoA, ADDR root2, 10, \
        ADDR buf, SRC1_REAL or SRC2_DIMM
invoke  WriteConsoleA, stdout, ADDR buf, \
        BSIZE, ADDR cWritten, NULL
invoke  ExitProcess, 0
end start

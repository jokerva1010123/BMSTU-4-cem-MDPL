; А.Крупник "Изучаем Ассемблер" листинг 4.5
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
BSIZE	equ 20
.data?
simple  dw BSIZE dup(?)
.code
start:
mov ecx,BSIZE
mov bx, 1
mov edi, 0
nxt:
mov simple[edi],bx
inc bx
add edi, 2  ;переход к следующему числу
loop nxt
invoke  ExitProcess, 0
end start

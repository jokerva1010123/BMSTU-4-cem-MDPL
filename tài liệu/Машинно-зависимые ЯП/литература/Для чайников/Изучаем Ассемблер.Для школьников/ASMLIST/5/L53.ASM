; А.Крупник "Изучаем Ассемблер" листинг 5.3
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE     equ 20
.data
digit     db BSIZE dup (?)
cWritten  dd ?
stdout    dd ?
.code
start:  
mov  esi, BSIZE
mov  eax, 123456789
mov  ebx, 1315678
mul  ebx
mov  ebx, edx
mov  ecx,10     ;делим на 10
nxt: 
dec  esi        ;позиция след. символа
xchg eax, ebx   ;делим
sub  edx, edx   ; старшую
div  ecx        ; половину
xchg eax, ebx   ;сохраняем частное и делим
div  ecx        ;остаток + младшую половину
add  dl, 48     ;превращаем в символ 
mov  digit[esi], dl   ;сохраняем символ
mov  edx, ebx
or   edx, eax   ;оба частных = 0?
jnz  nxt        ;нет - продолжим
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov  stdout, eax
mov  eax, offset digit;начало массива
add  eax, esi         ;адрес первого
 		      ; символа
mov  edx, BSIZE
sub  edx, esi         ;число символов
invoke  WriteConsoleA, stdout, eax, edx, \
        ADDR cWritten, NULL
invoke  ExitProcess, 0
end start

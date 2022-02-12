; А.Крупник "Изучаем Ассемблер" листинг 4.6
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
SSIZE    equ 1000
.data?
smpl     dd SSIZE dup(?)
.code
start:
mov ebx, 3  ;первое проверяемое число = 3
mov edi, 0  ;нулевой элемент массива
mov ebp, 0  ;счетчик простых чисел = 0
nxtdig:
mov edx, 0  ;готовим число edx:eax
mov eax, ebx;к проверке
mov ecx, ebx;число проверок меньше
sub ecx, 2  ;проверяемого числа на 2
mov esi, 2  ;первый делитель = 2
nxtpr:
div esi     ;делим число edx:eax на esi
cmp edx, 0  ;остаток = 0 ?
jz  skip    ;да - идем к след. проверке
mov edx, 0  ;нет -
mov eax, ebx;восстанавливаем edx:eax
inc esi     ;и делим на следующее число
loop nxtpr  ;есть на что делить - продолжим
mov smpl[edi], ebx ; нет - число простое
inc ebp     ;увел. счетчик прост. чисел
cmp ebp, SSIZE;все простые числа найдены?
jz  done    ;да - уходим
add edi,4   ;нет - след. эл-т массива
skip:
inc  ebx    ;проверяем
jmp nxtdig  ;след. число
done:
invoke  ExitProcess, 0
end start

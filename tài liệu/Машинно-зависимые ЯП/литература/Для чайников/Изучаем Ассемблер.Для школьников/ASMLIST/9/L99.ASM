; А.Крупник "Изучаем Ассемблер" листинг 9.9
.8086
ARRSIZE equ 20
stack segment stack 
db 100 dup (?)
stack ends
code segment
assume cs:code, ds:code, ss:stack
start:
mov  bx, offset array
mov  si, 5
shl  si, 1
mov  word ptr [bx+si], 3
mov  ah, 4ch
int  21h
array dw ARRSIZE dup (?)
code ends
end  start

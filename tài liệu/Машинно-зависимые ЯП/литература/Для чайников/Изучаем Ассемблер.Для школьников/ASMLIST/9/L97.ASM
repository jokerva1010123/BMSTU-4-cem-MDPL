; А.Крупник "Изучаем Ассемблер" листинг 9.7
.8086
stack segment stack 
db 100 dup (?)
stack ends
code segment
assume cs:code, ss:stack
start:
mov bx, offset f_add
push cs     ;сохранить сегмент
call bx     ;вызов f_add
mov  ah, 4ch
int  21h
f_add proc far
mov   ax, 2
add   ax, 3
ret
f_add endp
code ends
end  start

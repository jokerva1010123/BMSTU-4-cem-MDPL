; А.Крупник "Изучаем Ассемблер" листинг 9.8
.8086
stack segment stack 
db 100 dup (?)
stack ends
code segment
assume cs:code, ss:stack
start:
push cs
call nearp
call farp
mov  ah, 4ch
int  21h
f_add proc far
mov   ax, 2
add   ax, 3
ret
f_add endp
nearp dw f_add
farp  dd f_add
code ends
end  start

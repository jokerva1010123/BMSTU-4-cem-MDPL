; А.Крупник "Изучаем Ассемблер" листинг 9.4
.8086
stack segment stack 
db 100 dup (?)
stack ends
hay1   segment 
equal  db "Равны", 13, 10, '$'
nequal db "Не равны", 13, 10, '$'
src db "сеносеносеносеносеносено"
zsize   dw ($-src)
hay1  ends
hay2   segment 
dst db  "сеносеноиголкасеносеносe"
hay2  ends
code segment
assume cs:code, ds:hay1, es:hay2, ss:stack
start:
cld
mov  ax, hay1
mov  ds, ax
mov  ax, hay2
mov  es, ax
mov  si, offset src
mov  di, offset dst
mov  cx, zsize
repe cmpsb
mov  dx, offset nequal
cmp  cx, 0
jnz  disp
mov  dx, offset equal
disp:
mov  ah, 09
int  21h
mov  ah, 4ch
int  21h
code ends
end  start

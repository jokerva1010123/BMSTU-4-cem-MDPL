; А.Крупник "Изучаем Ассемблер" листинг 8.3
.8086
stack segment stack 
db 100 dup (?)
stack ends
data   segment
first  dw 2
data   ends
data1  segment
second dw 3
data1  ends
code segment
assume cs:code, ds:data, es:data1, ss:stack
start:
mov  ax, data
mov  ds, ax
mov  ax, data1
mov  es, ax
mov  bx, 0
mov  dx, [bx]
mov  ah, 4ch
int  21h
code ends
end  start

; А.Крупник "Изучаем Ассемблер" листинг 9.3
.286
stack segment stack 
db 100 dup (?)
stack ends
north_sea   segment 
src dw  3
north_sea  ends
south_sea   segment 
dst dw ?
south_sea  ends
code segment
assume cs:code, ds:north_sea, es:south_sea 
assume ss:stack
start:
mov  ax, north_sea
mov  ds, ax
mov  ax, south_sea
mov  es, ax
mov  si, offset src
mov  di, offset dst
movsw
mov  ah, 4ch
int  21h
code ends
end  start

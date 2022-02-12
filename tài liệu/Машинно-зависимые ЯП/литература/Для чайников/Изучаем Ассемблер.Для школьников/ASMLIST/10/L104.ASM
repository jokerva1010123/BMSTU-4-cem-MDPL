; А.Крупник "Изучаем Ассемблер" листинг 10.4
Quit macro
     mov   ah, 4ch
     int   21h
endm
LDisp macro line
      mov   dx, offset line
      mov   ah, 09
      int   21h
endm
.8086
.MODEL  small
option casemap:none
.stack 100
.data
hello  db "Не могу молчать!", 0dh, 0ah, '$'
.code
start:
mov  dx,@stack
mov  ss,dx
mov  dx,@data 
mov  ds,dx    ;регистр данных
LDisp hello   ;вывод на экран
Quit          ;уходим
end  start

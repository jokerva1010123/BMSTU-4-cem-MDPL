; А.Крупник "Изучаем Ассемблер" листинг 8.1
.8086
.MODEL  small
.stack 100
.data
hello db  "Не могу молчать!", 0dh, 0ah, '$'
.code
start:
mov  dx,@stack
mov  ss,dx
mov  dx,@data ;
mov  ds,dx    ;регистр данных
mov  dx, offset hello
mov  ah, 09   ;вывести на экран
int  21h
mov  ah, 4ch  ;завершить программу
int  21h
end  start

; А.Крупник "Изучаем Ассемблер" листинг 9.1
.8086
stack segment stack 
db 100 dup (?)
stack ends
code1  segment 
assume cs:code1
addd:
mov    ax, 2
add    ax, 3
jmp far ptr exit
code1  ends
code segment
assume cs:code, ss:stack
start:
jmp  far ptr addd
exit:
mov  ah, 4ch
int  21h
code ends
end  start

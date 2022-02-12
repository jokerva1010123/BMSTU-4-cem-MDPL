; А.Крупник "Изучаем Ассемблер" листинг 9.6
.8086
stack segment stack 
db 100 dup (?)
stack ends
code1  segment 
assume cs:code1
target:
jmp far ptr exit
code1  ends
code segment
assume cs:code, ss:stack
start:
mov ax, SEG target
push ax
mov ax, offset target
push ax
retf
exit:
mov  ah, 4ch
int  21h
code ends
end  start

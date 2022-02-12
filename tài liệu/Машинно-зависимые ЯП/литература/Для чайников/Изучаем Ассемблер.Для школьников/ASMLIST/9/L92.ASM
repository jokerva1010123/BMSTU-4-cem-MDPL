; А.Крупник "Изучаем Ассемблер" листинг 9.2
.8086
$w equ word ptr
$o equ offset
stack segment stack 
db 100 dup (?)
stack ends
code1  segment 
assume cs:code1
addd:
mov    ax, 2
add    ax, 3  
jmp far ptr disp ;возврат
code1  ends
code segment
assume cs:code, ss:stack
start:
mov $w faddr, $o addd
mov $w faddr[2], SEG addd
jmp faddr ;дальний переход
disp:
mov  ah, 4ch
int  21h
faddr dd ?
code ends
end  start

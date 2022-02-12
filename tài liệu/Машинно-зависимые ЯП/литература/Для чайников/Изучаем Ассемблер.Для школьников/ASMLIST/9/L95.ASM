; А.Крупник "Изучаем Ассемблер" листинг 9.5
.8086
stack segment stack 
db 100 dup (?)
stack ends
code1  segment 
assume cs:code1
f_add proc far
mov    ax, 2
add    ax, 3
ret         ;CB RET Far
f_add   endp
code1  ends
code segment
assume cs:code, ss:stack
start:
call f_add  ;9A00009E2E CALL   2E9E:0000
mov  ah, 4ch
int  21h
code ends
end  start

; А.Крупник "Изучаем Ассемблер" листинг 2.2
.386
.model  flat,stdcall
.code
start:
mov eax, 4000000000
add eax, 4000000000
ret
end start

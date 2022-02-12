; А.Крупник "Изучаем Ассемблер" листинг 3.4
.386
.model  flat,stdcall
.code
start:
mov ax,	2211h
mov ecx,66554433h
mov bl,[esp]; bl=37h
push ax
push ecx
pop  ax
pop  ecx
mov  ecx,[esp-6]; ecx=66554433h
mov  ax, [esp-2]; ax=2211h
ret
end start

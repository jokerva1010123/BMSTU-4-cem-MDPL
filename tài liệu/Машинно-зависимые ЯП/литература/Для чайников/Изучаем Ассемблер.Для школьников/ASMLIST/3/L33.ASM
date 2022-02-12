; А.Крупник "Изучаем Ассемблер" листинг 3.3
.386
.model  flat,stdcall
.code
start:
mov ax,  2211h
mov ecx, 66554433h
push ax	 ;esp=esp-2
push ecx ;esp=esp-4
pop  ax	 ;esp=esp+2, ax=4433h
pop  ecx ;esp=esp+4, ecx=22116655h
ret
end start

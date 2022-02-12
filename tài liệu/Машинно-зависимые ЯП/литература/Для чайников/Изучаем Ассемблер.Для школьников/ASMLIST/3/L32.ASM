; А.Крупник "Изучаем Ассемблер" листинг 3.2
.386
.model  flat,stdcall
.code
start:
mov eax, 2 ;eax = 2
mov ecx, 3 ;ecx = 3
push eax
push ecx
pop  eax   ;eax = 3
pop  ecx   ;ecx = 2
ret
end start

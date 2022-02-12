; А.Крупник "Изучаем Ассемблер" листинг 3.6
.386
.model  flat,stdcall
option casemap:none 
.code
start:
push dword ptr 2
push dword ptr 3
call AddDigs
ret
AddDigs proc
mov eax,[esp+8]	; eax=2
add eax,[esp+4]	; eax=5 
ret 8
AddDigs endp
end start

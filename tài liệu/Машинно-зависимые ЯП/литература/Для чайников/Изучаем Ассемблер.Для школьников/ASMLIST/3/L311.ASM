; А.Крупник "Изучаем Ассемблер" листинг 3.11
.386
.model  flat,stdcall
option casemap:none 
includelib \myasm\lib\kernel32.lib
ExitProcess proto :DWORD 
AddDigs proto :DWORD, :DWORD
.code
start:
invoke AddDigs,2,3
invoke ExitProcess,0
AddDigs proc arg1:DWORD,arg2:DWORD
mov eax,[esp+8]	; eax=2
add eax,[esp+12]; eax=5 
ret
AddDigs endp
end start

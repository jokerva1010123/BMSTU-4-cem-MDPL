; А.Крупник "Изучаем Ассемблер" листинг 3.8
.386
.model  flat,stdcall
option casemap:none 
includelib \myasm\lib\kernel32.lib
ExitProcess proto :DWORD
.code
start:
invoke ExitProcess, 0
end  start

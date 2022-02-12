; А.Крупник "Изучаем Ассемблер" листинг 3.9
.386
.model  flat, stdcall
option  casemap:none
ExitProcess   	proto :dword
GetStdHandle  	proto :dword
WriteConsoleA 	proto :dword,:dword,\
		:dword,:dword,:dword
includelib	\myasm\lib\kernel32.lib
.data
stdout   dd ?
msg      db "Не могу молчать!",0dh,0ah
cWritten dd ? 
.code
start:
invoke  GetStdHandle, -11
mov stdout, eax
invoke	WriteConsoleA, stdout, ADDR msg,\
	sizeof msg, ADDR    cWritten, 0
invoke	ExitProcess, 0
end start

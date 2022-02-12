; А.Крупник "Изучаем Ассемблер" листинг 6.2
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\user32.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
NOFDIG   equ 4
DSIZE    equ 4
BSIZE    equ NOFDIG*DSIZE
DIGSZ    equ 10
.data
fName    db "simple",0
fmt      db "%d",0 
fHandle  dd ?
stdout   dd ?
cRead    dd ?
cWritten dd ?
buf      dd BSIZE dup (?) 
dig2sim  db DIGSZ dup (?) 
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke CreateFile, ADDR fName,\ 
       GENERIC_READ,\ 
       0, NULL, OPEN_EXISTING,\ 
       FILE_ATTRIBUTE_NORMAL, 0    
mov    fHandle, eax
invoke ReadFile, fHandle, ADDR buf,\
       BSIZE, ADDR cRead, NULL
mov ecx, NOFDIG
mov esi, 0
nxt:
push ecx
invoke wsprintf, ADDR dig2sim,\ 
       ADDR fmt, buf[esi]  
invoke WriteConsole, stdout,\ 
       ADDR dig2sim,\  
       DIGSZ, ADDR cWritten, NULL
add esi,4 
pop ecx
loop nxt
invoke CloseHandle, fHandle  
invoke ExitProcess, 0
end start

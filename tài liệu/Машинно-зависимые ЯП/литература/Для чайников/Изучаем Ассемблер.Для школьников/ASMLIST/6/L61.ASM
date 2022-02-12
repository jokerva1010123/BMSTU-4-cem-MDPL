; А.Крупник "Изучаем Ассемблер" листинг 6.1
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
NOFDIG equ 4
DSIZE  equ 4
BSIZE  equ NOFDIG*DSIZE
.data
fName    db "simple",0
fHandle  dd ?
cWritten dd ?
digs     dd 3,5,7,11 
.code
start:
invoke CreateFile, ADDR fName, ;запятая - тоже признак продолжения
       GENERIC_WRITE,          ; строки
       0, NULL, CREATE_ALWAYS,
       FILE_ATTRIBUTE_ARCHIVE, 0
mov    fHandle, eax
invoke WriteFile, fHandle, ADDR digs,BSIZE,
       ADDR cWritten, NULL
invoke CloseHandle, fHandle
invoke ExitProcess, 0
end start

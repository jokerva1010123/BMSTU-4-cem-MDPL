; А.Крупник "Изучаем Ассемблер" листинг 6.6
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE  equ 128
.data
fName    db "cook",0
fHandle  dd ?
cRead    dd ?
cWrite   dd ?
cWritten dd ?
comma    db ","
buf      db BSIZE dup (?)
.code
start:
invoke CreateFile, ADDR fName,
       GENERIC_READ+GENERIC_WRITE,
       0, NULL, OPEN_EXISTING,
       FILE_ATTRIBUTE_NORMAL, 0    
mov    fHandle, eax
invoke SetFilePointer, fHandle, 7,
       NULL,FILE_BEGIN
invoke ReadFile, fHandle, ADDR buf,
       BSIZE, ADDR cRead, NULL
invoke SetFilePointer, fHandle, 7,
       NULL,FILE_BEGIN
invoke WriteFile, fHandle, ADDR comma,
       1, ADDR cWrite, NULL
invoke WriteFile, fHandle, ADDR buf,
       cRead, ADDR cWrite, NULL
invoke CloseHandle, fHandle
invoke ExitProcess, 0
end start

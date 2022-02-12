; А.Крупник "Изучаем Ассемблер" листинг 10.2
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
.data
z       	db  "равно нулю", 13, 10
zsize   	dd  ($-z)
nz      	db  "не равно нулю", 13, 10
nzsize  	dd  ($-nz)
digit   	dd  1
stdout		dd  ?
cWritten	dd  ?
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
.IF digit == 0
invoke  WriteConsoleA, stdout, ADDR z, \
        zsize, ADDR cWritten, NULL
.ELSE
invoke  WriteConsoleA, stdout, ADDR nz, \
        nzsize, ADDR cWritten, NULL
.ENDIF
invoke  ExitProcess, 0
end start

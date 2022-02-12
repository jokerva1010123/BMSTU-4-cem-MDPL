; А.Крупник "Изучаем Ассемблер" листинг 6.3
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
LLNG     equ 128
.data
stdout   dd ? ;дескриптор экрана
cWritten dd ? ;число показанных символов
CLIni    dd ? ;начало командной строки
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke GetCommandLine  ;адрес командной
                       ; строки
mov CLIni, eax         ;запомнить адрес
                       ; командной строки
mov edi, eax    ;edi = нач. ком. стр.
cld             ;будем увеличивать адрес
mov ecx, LLNG   ;макс. дл. ком. строки
mov al, 0       ;ищем 0
repne  scasb    ;поиск нуля
sub edi, CLIni  ;edi = длине строки
invoke  WriteConsole,  stdout,
        CLIni, edi, ADDR cWritten, NULL
invoke  ExitProcess, 0
end start

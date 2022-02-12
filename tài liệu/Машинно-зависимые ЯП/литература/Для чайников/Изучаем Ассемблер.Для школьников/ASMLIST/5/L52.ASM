; А.Крупник "Изучаем Ассемблер" листинг 5.2
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\user32.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
includelib \myasm\lib\user32.lib
DateDisp proto :WORD
BSIZE equ 15
.data
ifmt      db "%d",0
buf       db BSIZE dup(0)
stdout    dd ?
cWritten  dd ?
month	  db "янв фев мар апр май июн "
          db "июл авг сен окт ноя дек"
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax 
mov  ax, 0f383h     ;30 июля 2003 года
invoke DateDisp, ax ;показать дату
invoke  ExitProcess, 0
DateDisp proc Date:WORD
xor edi,edi         ;очищаем регистр
mov di, Date
rol di, 5           ;число - в пять младших
                    ; бит
and di, 1fh         ;гасим лишние биты
invoke  wsprintf, ADDR buf, ADDR ifmt, edi
invoke  WriteConsole, stdout, ADDR buf, 3,\
        ADDR cWritten, NULL
mov di, Date         ;восстанавливаем дату
shr di, 7            ;месяц - в семь
                     ; младших бит
and di, 0fh          ;выделяем месяц
dec di               ;нумерация с нуля
shl di, 2            ;умножим на 4
mov esi, offset month;отн. адрес названия
add esi, edi         ;адрес названия
invoke  WriteConsole, stdout, esi, 4, \
        ADDR cWritten, NULL
mov  di, Date        ;восстанавливаем дату
and  di, 7fh         ;выделяем год
invoke  wsprintf, ADDR buf, ADDR ifmt, edi
invoke  WriteConsole, stdout, ADDR buf, 3,\
        ADDR cWritten, NULL
ret
DateDisp endp
end start

;А.Крупник "Изучаем Ассемблер" листинг 6.3
;Листинг 6.5. Открытие файла
;Компиляция 
;          amake l65
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
GetFName proto
.data
fHandle  DWORD ?
stdout   DWORD ?
cWritten DWORD ?
error    BYTE "Нет такого файла"
noname   BYTE "Укажите имя файла"
.code
start:
main proc
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov     stdout, eax
invoke  GetFName
cmp     eax, -1
jz      empty
invoke  CreateFile, eax, 
        GENERIC_READ, 
        0, NULL, OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL, 0
cmp eax,INVALID_HANDLE_VALUE
jz  exit
mov     fHandle, eax
invoke  CloseHandle, fHandle
invoke  ExitProcess, 0
exit:
invoke  WriteConsoleA, stdout,
        ADDR error,
        sizeof error, ADDR cWritten, NULL
invoke  ExitProcess, 0
empty:
invoke  WriteConsoleA, stdout,
        ADDR noname,
        sizeof noname, ADDR cWritten, NULL
invoke  ExitProcess, 0
main endp
GetFName proc
invoke  GetCommandLine
mov     edi, eax 
push    edi
mov     al, 0 
mov     ecx,-1 
cld
repne   scasb 
not     ecx
pop     edi 
mov     al,20h 
repne   scasb
dec     edi
cmp     byte ptr [edi],0 
jz      empty 
inc     edi
mov     eax,edi 
ret
empty:
mov     eax,-1 
ret
ret
GetFName endp
end start

section .text

global strcopy

strcopy:
    ; SI - строка 2
    ; DI - строка 1
    mov rcx, rdx

not_equal:
    cmp rdi, rsi    ; сравнение что копировать и куда
    jl simple_copy  ; если первый операнд МЕНЬШЕ второго операнда - идет простое копирование

    mov rax, rdi
    sub rax, rsi    ; вычитаю si из ax

    cmp rax, rcx
    jge simple_copy  ; если первый операнд БОЛЬШЕ или РАВЕН второму, то простое копирование

simple_copy:
    rep movsb ; Префикс повторения команды   Копирование строк байтов
    cld       ; Команда CLD в Ассемблере очищает флаг направления (DF)

exit:
    ret

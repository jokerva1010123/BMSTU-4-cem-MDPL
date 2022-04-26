.MODEL TINY
.186            ; Работать с процессором 80186
.CODE

ORG 100H  

MAIN:
    JMP INIT

    ; данные резидентной программы
    CURRENT DB 0
    IS_INIT DB 'y'
    SPEED DB 1Fh
    OLD_BREAKING DD ?

MY_BREAKING:
    PUSHA                               ;сохраняет в стеке содержимое регистров общего назначения
    PUSH ES
    PUSH DS

    mov AL, 0F3h
    OUT 60h, AL                         ;инструкция OUT выводит данные из регистра AL или AX в порт ввода-вывода
    mov AL, SPEED
    OUT 60h, AL

    dec SPEED

    TEST SPEED, 1FH
    JZ RESET_SPEED
    JMP END_LOOP

    RESET_SPEED:
        mov SPEED, 1Fh

    END_LOOP:
        POP DS
        POP ES
        POPA

    JMP CS:OLD_BREAKING

; ES:BX = адрес обработчика прерывания
INIT:           ; инициализация
    mov AX, 3508h                       ; AH = 35H, AL = номер прерывания (08 - таймер)
                                        ; ES:BX = адрес обработчика прерывания
                                        ; возвращает значение вектора прерывания для INT (AL)
                                        ; то есть, загружает в BX 0000:[AL*4], а в ES - 0000:[(AL*4)+2].
    INT 21h                             ; Функция DOS: считать адрес обработчика прерывания

    CMP ES:IS_INIT, 'y'
    JE EXIT

    mov WORD PTR OLD_BREAKING, BX       ;Запоминаем адрес старого обработчика
    mov WORD PTR OLD_BREAKING + 2, ES   ;Запоминаем адрес ES

    mov AX, 2508h                       ;Устанавливаем своего обработчика 08 вместо обработчика по умолчанию
    mov DX, OFFSET MY_BREAKING          ;адрес программы обработки прерывания
    INT 21H                             

    mov DX, OFFSET INSTALL_MSG          ; Вывод сообщения
    mov AH, 9
    INT 21H

    mov DX, OFFSET INIT                 ; адрес первого байта за резидентным участком программы
    INT 27H

EXIT:
    PUSHA
    PUSH ES
    PUSH DS

    mov AX, 2508h
    mov DX, WORD PTR ES:OLD_BREAKING
    mov DS, WORD PTR ES:OLD_BREAKING + 2
    INT 21H

    mov AL, 0F3H
    OUT 60H, AL
    mov AL, 0
    OUT 60H, AL

    POP DS
    POP ES
    POPA

    mov AH, 49H                 ;Освободить блок распределенной памяти
    INT 21H

    mov DX, OFFSET UNINSTALL_MSG
    mov AH, 9H
    INT 21H
    
    mov AX, 4C00H
    INT 21H

    INSTALL_MSG   DB 'Resident$'
    UNINSTALL_MSG DB 'Not resident$'
END MAIN
PUBLIC OUTPUT						; Делаю метку OUTPUT публичной

DATAS SEGMENT PARA COMMON 'DATA'	; объявляю сегмент данных, кторый наложиться на другой сегмент данных
	LETTER1 DB 3	
DATAS ENDS							; с таким же именем

CODES SEGMENT PARA PUBLIC 'CODE'	; сегмент кода, который соедениться с сегментом , у которого то же название
    ASSUME CS:CODES, DS:DATAS		;  сегменты по умолчанию
OUTPUT:								; 
	MOV AH, 2						; вывод символа
    MOV DL, 13						; новая строка
    INT 21H							; вызов дос
    MOV DL, 10						; каретка в начало строки
    INT 21H							; вызов доса
    
    MOV DL, LETTER1 + 2				; в сегмент DL кладу букву, которую считала
    ADD DL, 20h						; увеличиваю ее код на 32 (в десятичной), чтобы сделать ее строчной
    
    INT 21H							; вызов доса 
	RET								; возврат к вызову этой метки
CODES ENDS							; 
END									; 

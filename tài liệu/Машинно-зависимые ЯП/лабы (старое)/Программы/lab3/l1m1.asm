;ЛАБ №3 ЗАДАНИЕ 1 МОДУЛЬ M1 (см. модуль M2)
Code	SEGMENT 
        ASSUME  CS:Code, DS:Data, SS:STEK
	PP1	PROC 
		PUSH	DS
		MOV		AX,0
		PUSH	AX
		mov		AX,Data ;загрузка в AX адреса сегмента 
		mov		DS,AX   ;данных  и установка DS
		mov		DX,OFFSET A1 ;DS:DX - адрес строки
		mov		AH,9    ;АН=09h выдать на дисплей строку
		int		21h     ;до символа ‘$’
		mov		AH,7    ;АН=07h ввести символ без эха
		INT		21h     ;с ожиданием 
	PP1	ENDP
Code    ENDS

Data	SEGMENT  'DATA'
	A1	DB	13    ;курсор поместить в нач. строки
		DB	10    ;перевести курсор на нов. строку
		DB	'A1'  ;текст сообщения 
		DB	'$'   ;ограничитель для функции DOS
Data   ENDS

STEK	SEGMENT STACK 'STACK'
        DW      128h DUP (?)
STEK	ENDS
        END   PP1

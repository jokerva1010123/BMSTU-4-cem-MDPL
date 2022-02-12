;ЛАБ №3 ЗАДАНИЕ 2 МОДУЛЬ M1 (см. модуль M2)
Code	SEGMENT PUBLIC
        ASSUME  CS:Code, DS:Data
	PP1	PROC 
        MOV		AX,DATA        ;загрузка в AX адреса сегмента данных
        MOV		DS,AX          ;установка DS
        MOV		DX,OFFSET A1   ;DS:DX - адрес строки
        MOV		AH,9           ;АН=09h выдать на дисплей строку
        INT		21H            ;вызов  функции DOS
        MOV		AH,7           ;АН=07h ввести символ без эха
        INT		21h            ;вызов  функции DOS
	PP1	ENDP
Code    ENDS

Data   SEGMENT PUBLIC 'DATA'
	A1    DB   13, 10, 'A1$' 
Data   ENDS
	END PP1
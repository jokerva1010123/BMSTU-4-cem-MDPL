;ЛАБ №3 ЗАДАНИЕ 1 МОДУЛЬ M2 (см. модуль M1)
Data	SEGMENT 'DATA'
	A2	DB	13, 10, 'A2$' 
Data	ENDS

Code    SEGMENT BYTE  
        ASSUME  CS:Code, DS:Data
	PP2	PROC FAR
		MOV		AX,DATA         
		MOV		DS,AX           
		MOV		DX,OFFSET A2 ;DS:DX - адрес строки
		MOV		AH,9         ;АН=09h выдать на дисплей строку
		INT		21H          ;вызов  функции DOS
		MOV		AH,7         ;АН=07h ввести символ без эха
		INT		21h          ;с ожиданием
		RET
	PP2	ENDP
Code    ENDS
        END   
;ЛАБ №3 ЗАДАНИЕ 3 МОДУЛЬ M2 (см. модуль M1)
Code	SEGMENT BYTE PUBLIC
		ASSUME  CS:Code
	PP2	PROC FAR
		mov		AH,9   ;АН=09h выдать на дисплей строку
		int		21h    ;вызов  функции DOS
		mov		AH,7   ;АН=07h ввести символ без эха
		INT		21h    ;вызов  функции DOS
		RET
	PP2	ENDP
Code	ENDS
	END   
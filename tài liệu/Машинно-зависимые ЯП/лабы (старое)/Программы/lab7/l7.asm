;															1.	PUTSTR MACRO  STR, LSTR	
;для вывода на экран в символьной форме битовой строки STR заданной длины LSTR в порядке уменьшения номера разряда.

;															2.	SET1  MACRO  POSBITA, ADRSTR
;выполняющую установку в 1 заданного разряда битовой строки

;															3.	KONSTRUKTOR   MACRO   STR, LIST	
;выполняющую в битовой строке STR установку в 1 разрядов, номера которых заданы константами в списке LIST

;															4.	SET0   MACRO   POSBITA, ADRSTR
;выполняющую сброс в 0 заданного разряда битовой строки

;															5.	COUNT   MACRO   STR, LSTR
;выполняющую подсчет числа 1 в разрядах битовой строки

;															6.	XaddY MACRO   X, Y
;выполняющую объединение битовых строк X:=X U Y

;															7.	XdelY MACRO   X, Y
;выполняющую вычитание битовых строк X:=X \ Y

;Использовать эти макросы для выполнения соответствующих работ над битовыми строками из 26 разрядов, описанными с помощью директив DB.

Data	SEGMENT								 ;|26
	X	DB	11000011b, 10011100b, 01000011b, 01000000b
	Y	DB	10001000b, 10001000b, 11111111b, 10000000b
	
	sX		DB	'bitstr X: ','$'
	xY		DB	'bitstr Y: ','$'
	sAdd	DB	'X u Y:    ','$'
	sDel	DB	'X \ Y:    ','$'
	sSet9	DB	'Setted 9: ','$'
	sCons	DB	'Constructed 0, 2, 7: ','$'
Data	ENDS

Code	SEGMENT
	ASSUME CS:Code, DS:Data
	
;-----------------------------------------------------
;перевод строки
;-----------------------------------------------------
PR_NewLine	PROC	NEAR
	PUSH	AX
	PUSH	DX
	
	MOV		AH,2
	MOV		DL,10
	INT		21h
	MOV		DL,13
	INT		21h
	
	POP		DX
	POP		AX
	RET
PR_NewLine	ENDP
;-----------------------------------------------------

;--------------------------------------------------------------------------------------
;Печатает переменную, переданную через стек, как десятичное число без знака (15 как 15, -15 как 65521)
;--------------------------------------------------------------------------------------
PR_Out10	PROC	NEAR
	PUSH	BP		;передаем параметр
	MOV		BP,SP
	PUSH	AX		;используем для деления
	PUSH	DX
	PUSH	BX
	
	MOV		AX,[BP+4]	;получаем в АХ число, которое надо распечатать
	MOV		BX,10		;делить будем на десять; BX целиком чтобы возникало деление двойного слова (и не возникало переполнения)
	
	;а теперь, алгоритм следующий: предположим в АХ лежит десятичное 123, тогда вначале мы выделим место под это число,
	;то есть > ___ , а потом будем печатать со сдвигом влево: > __3 , > _23 , > 123
	PUSH	AX	;сохраним АХ, потому что нам его два раза печатать

	LO10_Div1:
		MOV		DX,0
		DIV		BX
		PUSH	AX			;сохраним значение AX (целая часть)
			MOV		AH,2	;печатаем пропуск
			MOV		DL,'a'
			INT		21h
		POP		AX		
		CMP		AX,0
	JNE		LO10_Div1
	
	MOV	AH,2
	MOV DL,8	;делаем один откат назад
	INT 21h
	
	POP		AX
	LO10_Div2:
		MOV		DX,0
		DIV		BX
		PUSH	AX			;сохраним значение AX (целая часть)
			MOV		AH,2
			ADD		DL,'0'	;печатаем значение DX (остаток)
			INT		21h
			MOV		DL,8	;смещаемся назад ДВАЖДЫ
			INT		21h
			INT		21h
		POP		AX
		CMP		AX,0
	JNE		LO10_Div2
	
	
	POP		BX
	POP		DX
	POP		AX
	POP		BP
	RET
PR_Out10	ENDP
;--------------------------------------------------------------------------------------





















;-----------------------------------------------------
;печать битовой строки
;-----------------------------------------------------
PUTSTR	MACRO	STR, LSTR
	LOCAL	Lps_Loop1, Lps_Loop2, Lps_End
	
	PUSH	CX	;счетчик
	PUSH	DX	;печать
	PUSH	AX	;печать
	PUSH	BX	;буфер/счетчик
	PUSH	DI	;индекс
	
	MOV		DI,0
	MOV		BH,0	;в BH будем хранить количество распечатанных символов
	;через СТР передаем МАССИВ БАЙТОВ
	Lps_Loop1:
		MOV		BL,STR[DI]	;получаем DIй элемент этого массива
		MOV		CX,8
		Lps_Loop2:			;печатаем 8 бит этого элемента
			MOV		DH,0
			MOV		DL,BL	;загружаем в DX элемент
			DEC		CX
			SHR		DX,CL	;получаем его CLй бит
			INC		CX
			AND		DL,0001b;чистим из DL лишние три бита
			ADD		DL,'0'	;печатаем CLй бит
			MOV		AH,2
			INT		21h
			
			INC	BH
			CMP	BH,LSTR		;если превысили количество печати - абандон тред
			JE	Lps_End
		LOOP	Lps_Loop2
		
		INC		DI			;переходим к следующему элементу массива
		CMP		DI,4		;абандон тред если массив кончился
	JB		Lps_Loop1
		
	Lps_End:
	CALL	PR_NewLine
	POP		DI
	POP		BX
	POP		AX
	POP		DX
	POP		CX
ENDM
;-----------------------------------------------------




;-----------------------------------------------------
;установка разряда в 1
;-----------------------------------------------------
SET1	MACRO	STR, POS
	PUSH	DI	;индекс
	PUSH	CX	;буфер
	PUSH	AX	;буфер
	
	;через СТР передаем МАССИВ БАЙТОВ
	MOV		DI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		CX,8	;в AL останется индекс элемента (с конца), в котором лежит разряд,
	DIV		CL		;в AH - разряд относительно этого элемента
	MOV		CL,AH	;сохраним новый разряд
	MOV		AH,0
	SUB		DI,AX	;и индекс
	
	MOV		AH,0
	MOV		AL,STR[DI]	;получаем нужный элемент
	MOV		CH,1
	SHL		CH,CL		;сформируем маску
	OR		AL,CH		;установим нужный бит
	MOV		STR[DI],AL	;сохраним полученное значение обратно в память
	
	POP		AX
	POP		CX
	POP		DI	
ENDM
;-----------------------------------------------------




;-----------------------------------------------------
;установка в 1 разрядов из LIST
;-----------------------------------------------------
KONSTRUKTOR	MACRO	STR, LIST
	IRP BIT,<LIST>
		SET1 STR, BIT
	ENDM
ENDM
;-----------------------------------------------------




;-----------------------------------------------------
;поиск количества единиц и возвращение их в AX
;-----------------------------------------------------
COUNT MACRO   STR, LSTR
	LOCAL	Lc_Loop1, Lc_Loop2, Lc_End, Lc_Skip
	
	PUSH	CX	;счетчик
	PUSH	BX	;буфер/счетчик
	PUSH	DI	;индекс
	PUSH	AX
	
	MOV		AX,0
	MOV		DI,0
	MOV		BH,0	;в BH будем хранить количество пройденных символов
	;через СТР передаем МАССИВ БАЙТОВ
	Lc_Loop1:
		MOV		BL,STR[DI]	;получаем DIй элемент этого массива
		MOV		CX,8
		Lc_Loop2:			;анализируем 8 бит этого элемента
			PUSH	CX
			MOV		CX,1
			SHL		BL,CL	;выдвигаем крайний слева бит
			POP		CX
			JNC		Lc_Skip	;если выдвинули 1 - то запомним это
				INC		AX
			Lc_Skip:
			INC	BH
			CMP	BH,LSTR		;если превысили количество поиска - абандон тред
			JE	Lc_End
		LOOP	Lc_Loop2
		
		INC		DI			;переходим к следующему элементу массива
		CMP		DI,4		;абандон тред если массив кончился
	JB		Lc_Loop1
		
	Lc_End:
	PUSH	AX
	CALL	PR_Out10
	ADD		SP,2
	CALL	PR_NewLine
	
	POP		AX
	POP		DI
	POP		BX
	POP		CX
ENDM
;-----------------------------------------------------


;-----------------------------------------------------
;установка разряда в 0
;-----------------------------------------------------
SET0	MACRO	STR, POS
	PUSH	DI	;индекс
	PUSH	CX	;буфер
	PUSH	AX	;буфер
	
	;через СТР передаем МАССИВ БАЙТОВ
	MOV		DI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		CX,8	;в AL останется индекс элемента (с конца), в котором лежит разряд,
	DIV		CL		;в AH - разряд относительно этого элемента
	MOV		CL,AH	;сохраним новый разряд
	MOV		AH,0
	SUB		DI,AX	;и индекс
	
	MOV		AH,0
	MOV		AL,STR[DI]	;получаем нужный элемент
	MOV		CH,11111110b
	ROL		CH,CL		;сформируем маску
	AND		AL,CH		;установим нужный бит
	MOV		STR[DI],AL	;сохраним полученное значение обратно в память
	
	POP		AX
	POP		CX
	POP		DI	
ENDM
;-----------------------------------------------------


;-----------------------------------------------------
;объединение строк X= X U Y
;-----------------------------------------------------
XaddY MACRO   X, Y
	LOCAL	Lxay_Loop
	PUSH	DI	;индекс
	PUSH	AX	;буфер
	
	MOV		DI,0
	;через Х и У передаем МАССИВЫ БАЙТОВ
	Lxay_Loop:
		MOV		AH,X[DI]	;получаем DIй элемент массива Х
		MOV		AL,Y[DI]	;получаем DIй элемент массива У
		OR		AH,AL
		MOV		X[DI],AH
		INC		DI			;переходим к следующему элементу массива
		CMP		DI,4		;абандон тред если массив кончился
	JB		Lxay_Loop		
	
	POP		AX
	POP		DI
ENDM
;-----------------------------------------------------


;-----------------------------------------------------
;разность строк X= X \ Y
;-----------------------------------------------------
XdelY MACRO   X, Y
	LOCAL	Lxdy_Loop
	PUSH	DI	;индекс
	PUSH	AX	;буфер
	PUSH	BX	;буфер
	
	MOV		DI,0
	;через Х и У передаем МАССИВЫ БАЙТОВ
	Lxdy_Loop:
		MOV		AH,X[DI]	;получаем DIй элемент массива Х
		MOV		BH,AH
		MOV		AL,Y[DI]	;получаем DIй элемент массива У
		XOR		AH,AL
		AND		AH,BH
		MOV		X[DI],AH
		INC		DI			;переходим к следующему элементу массива
		CMP		DI,4		;абандон тред если массив кончился
	JB		Lxdy_Loop		
	
	POP		BX
	POP		AX
	POP		DI
ENDM
;-----------------------------------------------------







	
START:
	MOV		AX,Data
	MOV		DS,AX
	
	
	MOV		AH,9
	LEA		DX,sX
	INT		21h
	PUTSTR	X,32
	
	MOV		AH,1
	INT		21h
	
	MOV		AH,9
	LEA		DX,sY
	INT		21h
	PUTSTR	Y,32
	
	MOV		AH,1
	INT		21h
	
	
	MOV		AH,9
	LEA		DX,sAdd
	INT		21h
	XaddY	X,Y
	PUTSTR	X,32
	
	MOV		AH,1
	INT		21h
	
	
	MOV		AH,9
	LEA		DX,sDel
	INT		21h
	XdelY	X,Y
	PUTSTR	X,32
	
	MOV		AH,1
	INT		21h
	
	
	MOV		AH,9
	LEA		DX,sSet9
	INT		21h
	SET1	X,9
	PUTSTR	X,32
	
	MOV		AH,1
	INT		21h
	
	
	MOV		AH,9
	LEA		DX,sSet9
	INT		21h
	SET0	X,9
	PUTSTR	X,32
	
	MOV		AH,1
	INT		21h
	
	
	MOV		AH,9
	LEA		DX,sCons
	INT		21h
	CONSTRUKTOR	X,9
	PUTSTR	X,32
	
	MOV		AH,1
	INT		21h
	
	
	COUNT	X,32
	PUTSTR	X,32
	
	
	MOV		AH,4Ch
	MOV		AL,0
	INT		21h
	
Code	ENDS

Stack	SEGMENT	STACK
	DW	128h	DUP (?)
Stack	ENDS

END	START
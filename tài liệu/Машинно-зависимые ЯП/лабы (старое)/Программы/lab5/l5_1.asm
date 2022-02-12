;1.	Составить процедуру упорядочения по возрастанию первых N (N<=60) элементов
;символьного массива X методом поиска максимального элемента. Исходную строку
;и упорядоченную вывести на экран. 



Data	SEGMENT
	X	DB 60 DUP (?)
	N	DB (?)
Data	ENDS

Code	SEGMENT
	ASSUME CS:Code, DS:Data, SS:Stack
START:
	MOV	AX,Data
	MOV	DS,AX
	
;тут будет ввод размера N
;	MOV	DL,A		;вывод символа
;	MOV	AH,2
;	INT	21h
;	
;	MOV	AH,7		;ввод символа
;	INT	21h
	
;тут будет ввод элементов
;	MOV		CX, WORD PTR N
;	MOV		SI,0
;	M_ENTER:
;		MOV		AH,7		;вводим символ
;		INT		21h
;		MOV		DL,AL		;печатаем символ
;		MOV		AH,2
;		INT		21h
;		SUB		AL,'0'		;получаем ЧИСЛО из его НОМЕРА
;		MOV		X[SI],AL	;записываем число в массив
;		
;		ADD		SI,1
;	LOOP	M_ENTER	;вводим N чисел массива

	MOV		N,5
	
	MOV		X[0],3
	MOV		X[1],8
	MOV		X[2],1
	MOV		X[3],2
	MOV		X[4],1
	
	;печать-плейсхолдер
	MOV CH,0
	MOV CL,N
	MOV DI,OFFSET X
	P_1:
		MOV AH,2
		MOV DL,[DI]
		ADD DL,'0'
		INT 21h
		MOV DL,' '
		INT 21h
		INC DI
	LOOP P_1
	MOV DL,10
	INT 21h
	MOV DL,13
	INT 21h
	
	MOV		BH,0
	MOV		BL,N					;for bl=n; bl>0; bl--
	S_OUT:	;цикл через BX
		MOV		CH,0
		MOV		CL,N
		SUB		CL,1
		MOV		DI,0				;for j=0; j<=N-1; j++
		S_IN: ;цикл через CX
			MOV		DL,X[DI]
			MOV		DH,X[DI+1]
			CMP		DL,DH			;if X[j]>X[j+1]
			JLE S_SKIP
				MOV		AH,X[DI]
				XCHG	X[DI+1],AH
				MOV		X[DI],AH
			S_SKIP:
			INC		DI
		LOOP S_IN
	DEC		BX
	JNZ		S_OUT
	
	;печать-плейсхолдер
	MOV CH,0
	MOV CL,N
	MOV DI,OFFSET X
	P_2:
		MOV AH,2
		MOV DL,[DI]
		ADD DL,'0'
		INT 21h
		MOV DL,' '
		INT 21h
		INC DI
	LOOP P_2
	MOV DL,10
	INT 21h
	MOV DL,13
	INT 21h
	
	MOV		AL,0		;выход
	MOV		AH,4Ch
	INT		21h

Code	ENDS


Stack	SEGMENT STACK
	DW	128h DUP (?)
Stack	ENDS

	END START
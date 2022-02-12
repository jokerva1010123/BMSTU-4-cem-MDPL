PUBLIC	PR_InputInt
EXTRN	sEnter:BYTE

Data	SEGMENT	PUBLIC
	sSucceed	DB	13,10,'<entered>',13,10,'$'
Data	ENDS

Code	SEGMENT	PUBLIC
	ASSUME CS:Code


;--------------------------------------------------------------------------------------
;Ввод целого числа со знаком и без; возвращает введенное число через AX
;--------------------------------------------------------------------------------------
PR_InputInt	PROC	NEAR
	PUSH	BX		;в ВХ будем хранить промежуточный результат ввода
	PUSH	DX		;DX для печати
	PUSH	SI		;наличие знака
	MOV		AX,0
	MOV		BX,0
	
	MOV		AH,9
	LEA		DX,sEnter	;воспользуемся пока что ДХ чтобы вывести приглашение к вводу
	INT		21h
	MOV		DX,0
	LII_Loop:
		MOV		AH,1
		INT		21h		;получаем в АЛ символ
		
		CMP		AL,13	;если в АЛ - ентер, то закругляемся
		JE		LII_Success
		
		CMP		AL,2Dh
		JNE		LII_NotMinus
			MOV	SI,1	;запомним что число отрицательное
			JMP	LII_Loop
		LII_NotMinus:
		
		;#define юзверь не дурак и вводит только цифры
		PUSH	AX		;сохраним символ..
		MOV		AX,BX
		MOV		BX,10	;потомучто ассемблер не умеет в MUL 10
		MUL		BX		;умножаем уже введенную часть на 10..
		POP		BX		;получим обратно символ..
		SUB		BL,'0'	;преобразуем символ в цифру..
		MOV		BH,0
		ADD		BX,AX	;добавим цифру к введенной части.
	JMP	LII_Loop
	
	LII_Success:
	MOV	AX,BX
	CMP	SI,1	;если нужно, то умножим на -1
	JNE	LII_End
		NEG	AX
	LII_End:
	
	PUSH	AX
	LEA		DX,sSucceed
	MOV		AH,9
	INT		21h
	POP		AX
	POP		SI
	POP		DX
	POP		BX
	RET	
PR_InputInt	ENDP
;--------------------------------------------------------------------------------------

Code	ENDS

END
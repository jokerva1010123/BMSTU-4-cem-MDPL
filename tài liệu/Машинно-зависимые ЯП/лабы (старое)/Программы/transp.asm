Data	SEGMENT
	N	EQU 4
	M	DB N DUP (N DUP (?)) ; матрица 4x4
Data	ENDS

Code	SEGMENT
	ASSUME CS:Code, DS:Data
BEGIN:
	MOV		AX,Data
	MOV		DS,AX
	
	;заполняем матрицу: | a b c d | e f g h | и так далее
	MOV 	AL,'a'
	MOV		DI,OFFSET M ;записываем в ДИ адрес матрицы &M
	MOV		CX,N
	F_1:			;for i=0, i<N
		PUSH	CX
		MOV		CX,N
		F_2:		;for j=0, j<N
			MOV		[DI],AL	;в M+i*N+j записываем букву
			INC		DI
			INC		AL
		LOOP	F_2
		POP		CX
	LOOP	F_1
	
	;печатаем матрицу
	MOV		AH,2		;будем печатать символы'
	MOV		DI,OFFSET M
	MOV		CX,N
	P_11:
		PUSH	CX
		MOV		CX,N
		P_12:
			MOV		DL,[DI]	;подготавливаем под печать M+i*N+j
			INT		21h		;печатаем
			MOV		DL,' '
			INT		21h
			INC		DI
		LOOP	P_12
		POP		CX
		MOV		DL,10	;переводим строку
		INT		21h
		MOV		DL,13
		INT		21h
	LOOP	P_11
	
	;транспонируем матрицу: в i строке для j столбца делаем swap(x+i*N+j,x+i+j*N)
	MOV		SI,1	;i, =1 так как x[0][0] не транспонируется
	T_1:
		MOV		DI,0	;j
		T_2:
			MOV		AX,SI	;i
			MOV		DX,N
			MUL		DX		;i*n
			ADD		AX,DI	;i*n+j
			MOV		BL,AL
			
			MOV		AX,DI	;j
			MOV		DX,N
			MUL		DX		;j*n
			ADD		AX,SI	;i+j*n
			MOV		BH,AL
			
			PUSH SI		;они нам понадобятся при дальнейших счетах
			PUSH DI
			MOV		DH,0	;костыли!
			MOV		DL,BL	;SI\DI не умеют работать с байтами
			MOV		SI,DX	;поэтому приходится с помощью DX
			MOV		DL,BH	;переводить BL\BH в слова
			MOV		DI,DX
			MOV		AH,M[DI]	;swap(x+ i*N +j , x+ i+ j*N)
			XCHG	M[SI],AH
			MOV		M[DI],AH
			POP DI
			POP SI
			INC		DI	;j++		
			
			CMP		DI,SI
		JB		T_2
		INC		SI	;i++
		CMP		SI,N
	JB		T_1
	
	;печатаем результат
	MOV		AH,2
	MOV		DL,10
	INT		21h
	MOV		DI,OFFSET M
	MOV		CX,N
	P_21:
		PUSH	CX
		MOV		CX,N
		P_22:
			MOV		DL,[DI]	;подготавливаем под печать M+i*N+j
			INT		21h		;печатаем
			MOV		DL,' '
			INT		21h
			INC		DI
		LOOP	P_22
		POP		CX
		MOV		DL,10	;переводим строку
		INT		21h
		MOV		DL,13
		INT		21h
	LOOP	P_21
			
	;выход
	MOV		AH,4Ch
	MOV		AL,0
	INT		21h
Code	ENDS


Stack	SEGMENT STACK
	DB 128h DUP (?)
Stack	ENDS

	END BEGIN
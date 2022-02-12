;															1.	PUTSTR MACRO  STR, LSTR	
;��� ������ �� ����� � ���������� ����� ������� ������ STR �������� ����� LSTR � ������� ���������� ������ �������.

;															2.	SET1  MACRO  POSBITA, ADRSTR
;����������� ��������� � 1 ��������� ������� ������� ������

;															3.	KONSTRUKTOR   MACRO   STR, LIST	
;����������� � ������� ������ STR ��������� � 1 ��������, ������ ������� ������ ����������� � ������ LIST

;															4.	SET0   MACRO   POSBITA, ADRSTR
;����������� ����� � 0 ��������� ������� ������� ������

;															5.	COUNT   MACRO   STR, LSTR
;����������� ������� ����� 1 � �������� ������� ������

;															6.	XaddY MACRO   X, Y
;����������� ����������� ������� ����� X:=X U Y

;															7.	XdelY MACRO   X, Y
;����������� ��������� ������� ����� X:=X \ Y

;������������ ��� ������� ��� ���������� ��������������� ����� ��� �������� �������� �� 26 ��������, ���������� � ������� �������� DB.

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
;������� ������
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
;�������� ����������, ���������� ����� ����, ��� ���������� ����� ��� ����� (15 ��� 15, -15 ��� 65521)
;--------------------------------------------------------------------------------------
PR_Out10	PROC	NEAR
	PUSH	BP		;�������� ��������
	MOV		BP,SP
	PUSH	AX		;���������� ��� �������
	PUSH	DX
	PUSH	BX
	
	MOV		AX,[BP+4]	;�������� � �� �����, ������� ���� �����������
	MOV		BX,10		;������ ����� �� ������; BX ������� ����� ��������� ������� �������� ����� (� �� ��������� ������������)
	
	;� ������, �������� ���������: ����������� � �� ����� ���������� 123, ����� ������� �� ������� ����� ��� ��� �����,
	;�� ���� > ___ , � ����� ����� �������� �� ������� �����: > __3 , > _23 , > 123
	PUSH	AX	;�������� ��, ������ ��� ��� ��� ��� ���� ��������

	LO10_Div1:
		MOV		DX,0
		DIV		BX
		PUSH	AX			;�������� �������� AX (����� �����)
			MOV		AH,2	;�������� �������
			MOV		DL,'a'
			INT		21h
		POP		AX		
		CMP		AX,0
	JNE		LO10_Div1
	
	MOV	AH,2
	MOV DL,8	;������ ���� ����� �����
	INT 21h
	
	POP		AX
	LO10_Div2:
		MOV		DX,0
		DIV		BX
		PUSH	AX			;�������� �������� AX (����� �����)
			MOV		AH,2
			ADD		DL,'0'	;�������� �������� DX (�������)
			INT		21h
			MOV		DL,8	;��������� ����� ������
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
;������ ������� ������
;-----------------------------------------------------
PUTSTR	MACRO	STR, LSTR
	LOCAL	Lps_Loop1, Lps_Loop2, Lps_End
	
	PUSH	CX	;�������
	PUSH	DX	;������
	PUSH	AX	;������
	PUSH	BX	;�����/�������
	PUSH	DI	;������
	
	MOV		DI,0
	MOV		BH,0	;� BH ����� ������� ���������� ������������� ��������
	;����� ��� �������� ������ ������
	Lps_Loop1:
		MOV		BL,STR[DI]	;�������� DI� ������� ����� �������
		MOV		CX,8
		Lps_Loop2:			;�������� 8 ��� ����� ��������
			MOV		DH,0
			MOV		DL,BL	;��������� � DX �������
			DEC		CX
			SHR		DX,CL	;�������� ��� CL� ���
			INC		CX
			AND		DL,0001b;������ �� DL ������ ��� ����
			ADD		DL,'0'	;�������� CL� ���
			MOV		AH,2
			INT		21h
			
			INC	BH
			CMP	BH,LSTR		;���� ��������� ���������� ������ - ������� ����
			JE	Lps_End
		LOOP	Lps_Loop2
		
		INC		DI			;��������� � ���������� �������� �������
		CMP		DI,4		;������� ���� ���� ������ ��������
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
;��������� ������� � 1
;-----------------------------------------------------
SET1	MACRO	STR, POS
	PUSH	DI	;������
	PUSH	CX	;�����
	PUSH	AX	;�����
	
	;����� ��� �������� ������ ������
	MOV		DI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		CX,8	;� AL ��������� ������ �������� (� �����), � ������� ����� ������,
	DIV		CL		;� AH - ������ ������������ ����� ��������
	MOV		CL,AH	;�������� ����� ������
	MOV		AH,0
	SUB		DI,AX	;� ������
	
	MOV		AH,0
	MOV		AL,STR[DI]	;�������� ������ �������
	MOV		CH,1
	SHL		CH,CL		;���������� �����
	OR		AL,CH		;��������� ������ ���
	MOV		STR[DI],AL	;�������� ���������� �������� ������� � ������
	
	POP		AX
	POP		CX
	POP		DI	
ENDM
;-----------------------------------------------------




;-----------------------------------------------------
;��������� � 1 �������� �� LIST
;-----------------------------------------------------
KONSTRUKTOR	MACRO	STR, LIST
	IRP BIT,<LIST>
		SET1 STR, BIT
	ENDM
ENDM
;-----------------------------------------------------




;-----------------------------------------------------
;����� ���������� ������ � ����������� �� � AX
;-----------------------------------------------------
COUNT MACRO   STR, LSTR
	LOCAL	Lc_Loop1, Lc_Loop2, Lc_End, Lc_Skip
	
	PUSH	CX	;�������
	PUSH	BX	;�����/�������
	PUSH	DI	;������
	PUSH	AX
	
	MOV		AX,0
	MOV		DI,0
	MOV		BH,0	;� BH ����� ������� ���������� ���������� ��������
	;����� ��� �������� ������ ������
	Lc_Loop1:
		MOV		BL,STR[DI]	;�������� DI� ������� ����� �������
		MOV		CX,8
		Lc_Loop2:			;����������� 8 ��� ����� ��������
			PUSH	CX
			MOV		CX,1
			SHL		BL,CL	;��������� ������� ����� ���
			POP		CX
			JNC		Lc_Skip	;���� ��������� 1 - �� �������� ���
				INC		AX
			Lc_Skip:
			INC	BH
			CMP	BH,LSTR		;���� ��������� ���������� ������ - ������� ����
			JE	Lc_End
		LOOP	Lc_Loop2
		
		INC		DI			;��������� � ���������� �������� �������
		CMP		DI,4		;������� ���� ���� ������ ��������
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
;��������� ������� � 0
;-----------------------------------------------------
SET0	MACRO	STR, POS
	PUSH	DI	;������
	PUSH	CX	;�����
	PUSH	AX	;�����
	
	;����� ��� �������� ������ ������
	MOV		DI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		CX,8	;� AL ��������� ������ �������� (� �����), � ������� ����� ������,
	DIV		CL		;� AH - ������ ������������ ����� ��������
	MOV		CL,AH	;�������� ����� ������
	MOV		AH,0
	SUB		DI,AX	;� ������
	
	MOV		AH,0
	MOV		AL,STR[DI]	;�������� ������ �������
	MOV		CH,11111110b
	ROL		CH,CL		;���������� �����
	AND		AL,CH		;��������� ������ ���
	MOV		STR[DI],AL	;�������� ���������� �������� ������� � ������
	
	POP		AX
	POP		CX
	POP		DI	
ENDM
;-----------------------------------------------------


;-----------------------------------------------------
;����������� ����� X= X U Y
;-----------------------------------------------------
XaddY MACRO   X, Y
	LOCAL	Lxay_Loop
	PUSH	DI	;������
	PUSH	AX	;�����
	
	MOV		DI,0
	;����� � � � �������� ������� ������
	Lxay_Loop:
		MOV		AH,X[DI]	;�������� DI� ������� ������� �
		MOV		AL,Y[DI]	;�������� DI� ������� ������� �
		OR		AH,AL
		MOV		X[DI],AH
		INC		DI			;��������� � ���������� �������� �������
		CMP		DI,4		;������� ���� ���� ������ ��������
	JB		Lxay_Loop		
	
	POP		AX
	POP		DI
ENDM
;-----------------------------------------------------


;-----------------------------------------------------
;�������� ����� X= X \ Y
;-----------------------------------------------------
XdelY MACRO   X, Y
	LOCAL	Lxdy_Loop
	PUSH	DI	;������
	PUSH	AX	;�����
	PUSH	BX	;�����
	
	MOV		DI,0
	;����� � � � �������� ������� ������
	Lxdy_Loop:
		MOV		AH,X[DI]	;�������� DI� ������� ������� �
		MOV		BH,AH
		MOV		AL,Y[DI]	;�������� DI� ������� ������� �
		XOR		AH,AL
		AND		AH,BH
		MOV		X[DI],AH
		INC		DI			;��������� � ���������� �������� �������
		CMP		DI,4		;������� ���� ���� ������ ��������
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
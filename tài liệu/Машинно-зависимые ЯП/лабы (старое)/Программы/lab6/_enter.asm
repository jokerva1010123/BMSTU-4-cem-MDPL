PUBLIC	PR_InputInt
EXTRN	sEnter:BYTE

Data	SEGMENT	PUBLIC
	sSucceed	DB	13,10,'<entered>',13,10,'$'
Data	ENDS

Code	SEGMENT	PUBLIC
	ASSUME CS:Code


;--------------------------------------------------------------------------------------
;���� ������ ����� �� ������ � ���; ���������� ��������� ����� ����� AX
;--------------------------------------------------------------------------------------
PR_InputInt	PROC	NEAR
	PUSH	BX		;� �� ����� ������� ������������� ��������� �����
	PUSH	DX		;DX ��� ������
	PUSH	SI		;������� �����
	MOV		AX,0
	MOV		BX,0
	
	MOV		AH,9
	LEA		DX,sEnter	;������������� ���� ��� �� ����� ������� ����������� � �����
	INT		21h
	MOV		DX,0
	LII_Loop:
		MOV		AH,1
		INT		21h		;�������� � �� ������
		
		CMP		AL,13	;���� � �� - �����, �� ������������
		JE		LII_Success
		
		CMP		AL,2Dh
		JNE		LII_NotMinus
			MOV	SI,1	;�������� ��� ����� �������������
			JMP	LII_Loop
		LII_NotMinus:
		
		;#define ������ �� ����� � ������ ������ �����
		PUSH	AX		;�������� ������..
		MOV		AX,BX
		MOV		BX,10	;��������� ��������� �� ����� � MUL 10
		MUL		BX		;�������� ��� ��������� ����� �� 10..
		POP		BX		;������� ������� ������..
		SUB		BL,'0'	;����������� ������ � �����..
		MOV		BH,0
		ADD		BX,AX	;������� ����� � ��������� �����.
	JMP	LII_Loop
	
	LII_Success:
	MOV	AX,BX
	CMP	SI,1	;���� �����, �� ������� �� -1
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
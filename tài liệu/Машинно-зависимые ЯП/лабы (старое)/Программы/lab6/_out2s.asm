PUBLIC	PR_Out2S
EXTRN	PR_NewLine:NEAR
EXTRN	PR_Out2:NEAR






Code	SEGMENT	PUBLIC
	ASSUME CS:Code
;--------------------------------------------------------------------------------------
;�������� ����������, ���������� ����� ����, ��� �������� ����� �� ������ (4 ��� 100, -4 ��� -100)
;--------------------------------------------------------------------------------------
PR_Out2S	PROC	NEAR
	PUSH	BP		;�������� ��������
	MOV		BP,SP
	PUSH	AX
	
	MOV		AX,[BP+4]	;�������� � AX �����, ������� ���� �����������
	CMP		AX,0
	JGE		LO2S_SkipMinus	;���� ����� �������������, �� ������� - � ��������� "������������" �������� � ������
		PUSH	AX
		MOV		AH,2h
		MOV		DL,'-'
		INT		21h
		POP		AX
		NEG		AX
	LO2S_SkipMinus:
	PUSH	AX
	CALL	PR_Out2
	ADD		SP,2	;������ ����
	
	POP		AX
	POP		BP
	RET
PR_Out2S	ENDP
;--------------------------------------------------------------------------------------
Code	ENDS

END
PUBLIC	PR_Out16S
EXTRN	PR_NewLine:NEAR
EXTRN	PR_Out16:NEAR






Code	SEGMENT	PUBLIC
	ASSUME CS:Code
;--------------------------------------------------------------------------------------
;�������� ����������, ���������� ����� ����, ��� ����������������� ����� �� ������ (15 ��� F, -15 ��� -F)
;--------------------------------------------------------------------------------------
PR_Out16S	PROC	NEAR
	PUSH	BP		;�������� ��������
	MOV		BP,SP
	PUSH	AX
	
	MOV		AX,[BP+4]	;�������� � AX �����, ������� ���� �����������
	CMP		AX,0
	JGE		LO16S_SkipMinus	;���� ����� �������������, �� ������� - � ��������� "������������" �������� � ������
		PUSH	AX
		MOV		AH,2h
		MOV		DL,'-'
		INT		21h
		POP		AX
		NEG		AX
	LO16S_SkipMinus:
	PUSH	AX
	CALL	PR_Out16
	ADD		SP,2	;������ ����
	
	POP		AX
	POP		BP
	RET
PR_Out16S	ENDP
;--------------------------------------------------------------------------------------
Code	ENDS

END
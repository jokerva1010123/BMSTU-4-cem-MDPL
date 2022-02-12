;3.b. ��������� � ������������ � ���������� ����������� ��������� void TREE(int *U)
;��������� �������� ����� � ����� ������. ���� ������ ������ ����� ���� ���� WORD,
;�������������� � ������������ �����-��������� ������� :
;V � ��������� �� �������� (��� ����� ������ = 0),
;X � ������ � ����: ����� ���� 0..9,A..Z � �������� � ���� 0..9,A..Z,
;L � ��������� �� ������ ���������� (��� ����� ������ = 0),
;R � ��������� �� ������� ���������� (��� ����� ������ = 0).
;	void tree(int* A)
;	{
;		printf(A+2) //�������� ������� ��������
;		if *(A+4) != 0 //���� ���� ����� �����
;			tree(A+4) //���� � ����� �����
;		if *(A+6) != 0 //� ���� ���� ������ �����
;			tree(A+6) //�� ���� � ������ �����
;	}
;��� ������� ��������� ������ ������� � ������ �������� ������ (U0, U1,... ������������ ����) ���:
Data	SEGMENT
	
		DB 	(?) 		;�������, ����� ����� U0 != 0
	U0	DW	 0,'07',U1,U2
	U1	DW	U0,'13',U3,U4
	U2	DW	U0,'29',U5,U6
	U3	DW	U1,'31',U7,U8
	U4	DW	U1,'45',U9,UA
	U5	DW	U2,'58', 0, 0
	U6	DW	U2,'6A', 0, 0
	U7	DW	U3,'70', 0, 0
	U8	DW	U3,'82', 0, UB
	U9	DW	U4,'94', 0, 0
	UA	DW	U4,'A6', 0, 0
	UB	DW	U8,'BB', 0, 0
	
	sData	DB	'Node data: ','$'
Data	ENDS


Code	SEGMENT
	ASSUME CS:Code, DS:Data, SS:Stack
	
;==========================================================
PR_ProcessBranch	PROC	NEAR
;-----------------------------
;��������� ������������ ������, ������� � ������ ����, ���������� � DX, ����� "������"
;���������� ������ ���� (����� � ��������), ���� ���� ����� ����� - �� ��������� ������� ���� �� ���
;-----------------------------
	CMP		DX,0
	JNE		PRPB_WORK ;���� ��� �������� ������� - ������ �� ������, ����� ����������� �������
		RET
	PRPB_Work:
	
	PUSH	BX		;��������� �������� ��
	MOV		BX,DX	;� �� ����� ������� ������� �����, ��� ������ � ������������� ������
	
	MOV		DX,[BX+4]			;� �� ���������� �������� �� ������ �������� �������� - ����� ��� �������� �� ����� �����
	CALL	PR_ProcessBranch	;�������� ������� ��� ����� ������
	
	;� �� ����� ����� ����
	MOV		AH,2			;������ �������
	MOV		DL,[BX+3]		;�������� �������� ����
	INT		21h
	MOV		DL,[BX+2]		;�������� ����� ����
	INT		21h
	MOV		DL,32			;\t
	INT		21h	
	MOV		DX,0			;��������������� 0 � ��
	
	MOV		DX,[BX+6]
	CALL	PR_ProcessBranch	
	;���� �� ����� �� ����������� ������ �����, �� � ��� �� ��� ���� ����������, ������� ������������
	
	POP		BX ;������� ��������� - ��������������� �������� ��
	RET
PR_ProcessBranch	ENDP
;==========================================================



START:
	MOV		AX,Data
	MOV		DS,AX
	
	LEA		DX,DS:U0			;������� � �� ����� ����� ������
	CALL	PR_ProcessBranch	;POEKHALI!
	
	MOV		AL,0
	MOV		AH,4Ch
	INT		21h
Code	ENDS


Stack	SEGMENT STACK
	DW	128h DUP (?)
Stack	ENDS

	END START
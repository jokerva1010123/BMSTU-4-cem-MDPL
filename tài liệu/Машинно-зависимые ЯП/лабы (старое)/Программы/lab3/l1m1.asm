;��� �3 ������� 1 ������ M1 (��. ������ M2)
Code	SEGMENT 
        ASSUME  CS:Code, DS:Data, SS:STEK
	PP1	PROC 
		PUSH	DS
		MOV		AX,0
		PUSH	AX
		mov		AX,Data ;�������� � AX ������ �������� 
		mov		DS,AX   ;������  � ��������� DS
		mov		DX,OFFSET A1 ;DS:DX - ����� ������
		mov		AH,9    ;��=09h ������ �� ������� ������
		int		21h     ;�� ������� �$�
		mov		AH,7    ;��=07h ������ ������ ��� ���
		INT		21h     ;� ��������� 
	PP1	ENDP
Code    ENDS

Data	SEGMENT  'DATA'
	A1	DB	13    ;������ ��������� � ���. ������
		DB	10    ;��������� ������ �� ���. ������
		DB	'A1'  ;����� ��������� 
		DB	'$'   ;������������ ��� ������� DOS
Data   ENDS

STEK	SEGMENT STACK 'STACK'
        DW      128h DUP (?)
STEK	ENDS
        END   PP1

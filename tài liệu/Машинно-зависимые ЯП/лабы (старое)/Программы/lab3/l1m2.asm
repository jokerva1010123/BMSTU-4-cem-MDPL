;��� �3 ������� 1 ������ M2 (��. ������ M1)
Data	SEGMENT 'DATA'
	A2	DB	13, 10, 'A2$' 
Data	ENDS

Code    SEGMENT BYTE  
        ASSUME  CS:Code, DS:Data
	PP2	PROC FAR
		MOV		AX,DATA         
		MOV		DS,AX           
		MOV		DX,OFFSET A2 ;DS:DX - ����� ������
		MOV		AH,9         ;��=09h ������ �� ������� ������
		INT		21H          ;�����  ������� DOS
		MOV		AH,7         ;��=07h ������ ������ ��� ���
		INT		21h          ;� ���������
		RET
	PP2	ENDP
Code    ENDS
        END   
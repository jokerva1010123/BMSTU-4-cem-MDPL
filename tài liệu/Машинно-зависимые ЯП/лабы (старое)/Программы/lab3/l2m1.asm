;��� �3 ������� 2 ������ M1 (��. ������ M2)
Code	SEGMENT PUBLIC
        ASSUME  CS:Code, DS:Data
	PP1	PROC 
        MOV		AX,DATA        ;�������� � AX ������ �������� ������
        MOV		DS,AX          ;��������� DS
        MOV		DX,OFFSET A1   ;DS:DX - ����� ������
        MOV		AH,9           ;��=09h ������ �� ������� ������
        INT		21H            ;�����  ������� DOS
        MOV		AH,7           ;��=07h ������ ������ ��� ���
        INT		21h            ;�����  ������� DOS
	PP1	ENDP
Code    ENDS

Data   SEGMENT PUBLIC 'DATA'
	A1    DB   13, 10, 'A1$' 
Data   ENDS
	END PP1
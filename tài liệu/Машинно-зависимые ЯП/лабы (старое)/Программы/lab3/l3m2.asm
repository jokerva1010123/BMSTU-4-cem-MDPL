;��� �3 ������� 3 ������ M2 (��. ������ M1)
Code	SEGMENT BYTE PUBLIC
		ASSUME  CS:Code
	PP2	PROC FAR
		mov		AH,9   ;��=09h ������ �� ������� ������
		int		21h    ;�����  ������� DOS
		mov		AH,7   ;��=07h ������ ������ ��� ���
		INT		21h    ;�����  ������� DOS
		RET
	PP2	ENDP
Code	ENDS
	END   
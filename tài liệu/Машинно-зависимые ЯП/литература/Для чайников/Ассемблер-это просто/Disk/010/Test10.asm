
; ��। �믮������� ������ �ணࠬ��, �������� Prog10.com ������ ����
;                       㦥 ����㦥� � ������!

CSEG segment
assume CS:CSEG, DS:CSEG, ES:CSEG, SS:CSEG
org 100h

Begin:
	mov ah,9
	mov dx,offset String
	int 21h

	int 20h

String db 'My string.$'  ;�஡㥬 �뢥�� �� ��ப�

CSEG ends
end Begin

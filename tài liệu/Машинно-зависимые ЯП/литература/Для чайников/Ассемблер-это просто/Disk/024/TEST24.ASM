
;              TEST24.ASM - �ணࠬ�� � ����� � 24
;                ��� ��ᯥਬ��⮢ � ��ࠦ���ﬨ.

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db '�ਢ������ ���!',0Ah,0Dh,'$'

For_test db 35000 dup (0) ;!!! ��� 䠩� 㢥������ �� 35.000 ���� !!!

CSEG ends
end Begin
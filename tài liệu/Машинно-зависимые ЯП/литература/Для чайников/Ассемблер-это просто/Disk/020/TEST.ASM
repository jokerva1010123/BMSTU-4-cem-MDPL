
;		TEST20.ASM - �ணࠬ�� � ����� � 20
;		  ��� ��ᯥਬ��⮢ � ��ࠦ���ﬨ.

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db 'Hello!$'

CSEG ends
end Begin
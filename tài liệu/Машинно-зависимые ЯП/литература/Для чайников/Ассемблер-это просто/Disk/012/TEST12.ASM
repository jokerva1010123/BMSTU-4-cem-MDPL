
;		TEST12.ASM - �ணࠬ�� � ����� � 12

CSEG segment
assume cs:CSEG, ds:CSEG, ss:CSEG, es:CSEG
org 100h

Begin:
      mov ax,8899h	;�஢�ਬ, ����㦥� �� १�����?
      int 10h

      cmp ax,9988h
      je Ok_resident	;�᫨ ����㦥�, � �뢮��� ��ப� 

      mov ah,9		;�᫨ ���, � �뢮��� ᮮ⢥�����饥 ᮮ�饭��
      mov dx,offset No_resident
      int 21h

      ret		;� ��室�� �� �ணࠬ��

Ok_resident:
      mov ah,3		;����稬 ⥪���� ������ �����...
      mov bh,0
      int 10h
      push dx		;...� �������� ��

      mov ah,2		;����祬 �����
      mov dx,1900h	;���� ��⠭���� ��� �� �࠭��� ��࠭�
      int 10h

      mov ah,88h  ;�㭪�� 88h ���뢠��� 10h - �뢮� ��ப� (��� १�����!)
      mov si,offset String ;DS:SI - 㪠�뢠�� �� ��ப�
      int 10h	  ;�뢮���, �ᯮ���� ��� १�����

      xor ah,ah
      int 16h	  ;���� �������...

      pop dx	  ;����⠭���� ��࠭����� ���ﭨ� �����
      mov bh,0	  ;� ������� ��� ᭮��...
      mov ah,2
      int 10h

      ret	  ;����� �� ��� ⠪: int 20h, �� �� �� 1 ���� ������...


String db '��� ��ப� ��� �뢮�� !!!!!',0
No_resident db '�������� � ����� �� �����㦥�! ������� ���� redid12.com ᯥࢠ!$'

CSEG ends
end Begin

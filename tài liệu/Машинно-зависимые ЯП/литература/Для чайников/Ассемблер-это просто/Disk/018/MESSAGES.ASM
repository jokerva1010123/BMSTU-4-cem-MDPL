Mess_about db 0Ah, 0Dh, 'SuperShell - �����窠 ��� DOS, ����ᠭ��� �� ��ᥬ����.',0Ah, 0Dh
           db '����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS", ����� � 18',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����.',0Ah, 0Dh, 0Ah
           db 9,9,'=== �����, ��᪢�, 2000 ��� ===',0Ah,0Dh,'$'

Mess_head db ' Super Shell, ����� 1.0 ',0
Mess_down db ' �����, ��᪢�, 2000 ',0

Mess_qup db ' ��室 ',0
Mess_quit db ' �� ����⢨⥫쭮 ��� ��� � DOS (Y/N)?',0
Mess_quitl equ $-Mess_quit
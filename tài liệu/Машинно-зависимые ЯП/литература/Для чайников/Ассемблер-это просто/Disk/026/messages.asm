;   === MESSAGES.ASM - ���䨣��樮��� 䠩� ===

Begin_ini equ $

Mess_about db 0Ah, 0Dh, 'SuperShell - �����窠 ��� DOS, ����ᠭ��� �� ��ᥬ����.',0Ah, 0Dh
           db '����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS", ����� � 26',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����.',0Ah, 0Dh, 0Ah
           db 9,9,'=== �����, ��᪢�, 2001 ��� ===',0Ah,0Dh,'$'

Main_color dw 1F00h
Mess_head db 1Eh, ' Super Shell, ����� 1.0 ',0
Mess_down db 1Dh, ' �����, ��᪢�, 2001 ',0

Mess_qup db 4Eh, ' ��室 ',0
Mess_quit db 4Bh, ' �� ����⢨⥫쭮 ��� ��� � DOS (Y/N)?',0
Mess_quitl equ $-Mess_quit-1 ;���� ���� �������� ��� 梥� (4Bh)

Size_ini equ $-Begin_ini
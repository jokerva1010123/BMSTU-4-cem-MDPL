
;          TEST27.ASM - �������⥫쭠� �ணࠬ�� � ����� � 27

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;!!! ��� ���짮������ ������ �ணࠬ��� - �⠩� 27 ����� !!!

;   === ��砫� �ணࠬ�� ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

; --- �� ����! ---

Begin:
       mov ah,2
       mov cx,80

Next_char:
       mov dl,'A'
       int 21h
       loop Next_char

       ret

cseg ends
end Begin
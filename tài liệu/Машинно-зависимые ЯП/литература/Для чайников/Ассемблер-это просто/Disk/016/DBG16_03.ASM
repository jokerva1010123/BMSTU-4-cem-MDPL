
;              DBG16_03.ASM - �ணࠬ�� � ����� � 16

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE dbg16_03.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE dbg16_03.asm
;TLINK.EXE dbg16_03.obj /t/x


;                   === ���� �� �⫠�稪�� ===

; ���ᮡ ��⨩:
;��७��� �⥪ � ⥫� ��襩 �ணࠬ��. �⫠�稪, �ᯮ����騩 �⥪
;��襩 �ணࠬ�� ����� �� ���.

.286
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov sp,offset Label_1	;��⠭���� �⥪ � ⥫� ��襩 �ணࠬ��
				;��אַ �� �������� int 21h

       mov ah,9
       mov dx,offset Message
       int 21h

Label_1:
       int 20h

Message db 'DBG16_03.COM - ���冷�!$'

CSEG ends
end Begin
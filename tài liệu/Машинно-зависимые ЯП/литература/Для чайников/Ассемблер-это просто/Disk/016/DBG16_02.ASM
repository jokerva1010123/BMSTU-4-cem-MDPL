
;              DBG16_02.ASM - �ணࠬ�� � ����� � 16

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE dbg16_02.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE dbg16_02.asm
;TLINK.EXE dbg16_02.obj /t/x


;                   === ���� �� �⫠�稪�� ===

; ���ᮡ ��ன:
;������� ⠪, �⮡� �⫠�稪 ᠬ ᥡ� ����.

;��⠭�������� �⥪ � ������� ����஢ ���뢠���, � �筥� - �� ����
;03 ���뢠���.

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       cli
       mov sp,03h*4+2	;SP - ᬥ饭�� ���� 03 ���뢠��� + 2
			;(�⥪ ���� ᭨�� �����)

       xor ax,ax
       mov ss,ax	;SS = 0
			;������ �⥪ ��室���� � ������ ����஢ ���뢠���
			;�� ����饭�� � �⥪ �᫠, ���ࠥ��� ����
			;03 ���뢠���, �� "��蠥�" ��設� � �⫠�稪�

       nop		;<=== �⫠�稪 "��᭥�" �����!

       push cs		;����⠭���� �⥪...
       pop ss
       mov sp,0FFFEh

       sti
       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db 'DBG16_02.COM - ���冷�!$'

CSEG ends
end Begin
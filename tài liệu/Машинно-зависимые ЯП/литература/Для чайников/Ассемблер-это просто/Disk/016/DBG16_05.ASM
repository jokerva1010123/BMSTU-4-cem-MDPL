
;              DBG16_05.ASM - �ணࠬ�� � ����� � 016

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE dbg16_05.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE dbg16_05.asm
;TLINK.EXE dbg16_05.obj /t/x


;                   === ���� �� �⫠�稪�� ===

; ���ᮡ ����:
;��⠥� ᠬ� ᥡ� � ������

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov ax,3D00h		;���뢠�� 䠩� ��� �⥭��
       mov dx,offset File	;DX 㪠�뢠�� �� ��� 䠩��
       int 21h
       mov bx,ax
       push ax			;���࠭�� ����� 䠩��

       mov dx,offset Begin	;�㤠 �㤥� ���� (��砫� ��襩 �ணࠬ��)
       mov ah,3Fh		;�㭪�� �⥭�� 䠩��
       mov cx,offset Finish-100h ;����쪮 ���� �⠥� (����� �ணࠬ�� - 100h)
       int 21h			;<=== ����� �⫠�稪 "��������"

       pop bx
       mov ah,3Eh		;����뢠�� 䠩�
       int 21h


       mov ah,9
       mov dx,offset File
       int 21h

       int 20h


File db 'DBG16_05.COM',0,'- ���冷�!$'

Finish equ $

CSEG ends
end Begin
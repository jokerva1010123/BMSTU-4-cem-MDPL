
;              !DEBUG16.ASM - �ணࠬ�� � ����� � 16

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE !debug16.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE !debug16.asm
;TLINK.EXE !debug16.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       call Create_file	;�������� 䠩� � ������ "!Debug16.com"
			;���� ������, ��१���襬 ᠬ� ᥡ�...

       nop		;<=== �� ��� ���. �� �������� �� ��� ��ப�!

       ret		;��室�� � DOS


; === ��楤�� ᮧ����� 䠩�� � ������ "!DEBUG16.COM" ===
Create_file proc
       mov ah,3Ch		;�㭪�� ᮧ����� 䠩��
       xor cx,cx		;��ਡ��� �����
       mov dx,offset File	;��� ᮧ��������� 䠩��
       int 21h
       push ax			;���࠭�� ����� 䠩��

       mov bx,ax
       mov ah,40h ;�㭪�� ����� � 䠩�
       mov cx,offset Finish-100h ;���-�� �����뢠���� ����:
				 ;����� ��襩 �ணࠬ�� (Finish)-100h (PSP)
       mov dx,offset Begin	 ;����, � ���ண� ��稭��� �����
				 ;(ᠬ�� ��砫� ��襩 �ணࠬ��)
       int 21h

       pop ax
       mov ah,3Eh		;����뢠�� 䠩�
       int 21h

       ret

File db '!Debug16.com',0	;��� 䠩��, ���஥ ᮧ������
Create_file endp


Finish equ $	;��⪠ ���� �ணࠬ��

CSEG ends
end Begin
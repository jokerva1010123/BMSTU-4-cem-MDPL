
;              DBG16_01.ASM - �ணࠬ�� � ����� � 16

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE dbg16_01.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE dbg16_01.asm
;TLINK.EXE dbg16_01.obj /t/x


;                   === ���� �� �⫠�稪�� ===

; ���ᮡ ����:
; ������ �� ����� ��ࠡ��稪� 03h ���뢠��� ������� IRET

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       xor ax,ax
       mov es,ax		;����塞 ES

       mov bx,es:[03h*4]	;BX - ᬥ饭�� ���� 03 ���뢠���
       mov es,es:[03h*4+2]	;ES - ᥣ���� ���� 03 ���뢠���

       mov byte ptr es:[bx],0CFh ;<===�⫠�稪 "�����" �����
				 ;����ᨬ �� ����� ES:BX �������� IRET (0CFh)

       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db 'DBG16_01.COM - ���冷�!$'

CSEG ends
end Begin
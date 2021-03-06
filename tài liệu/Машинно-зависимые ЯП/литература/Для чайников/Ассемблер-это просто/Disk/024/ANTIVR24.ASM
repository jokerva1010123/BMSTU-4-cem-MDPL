
;              ANTIVR24.ASM - �ணࠬ�� � ����� � 24

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE antivr24.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE antivr24.asm
;TLINK.EXE antivr24.obj /t/x


;   === ��砫� �ணࠬ��: ===
.386               ;�ᯮ�짮���� �㤥� ॣ����� � ������� 386 ������
cseg segment use16 ;�� 㬮�砭�� 16-� ࠧ�來� �����
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
    jmp Init ; �� ���� ���樠����樨

; === ��楤�� ��ࠡ�⪨ 21h-���뢠��� ===
Int_21h_proc proc
      cmp ax,0ACDCh ;�஢�ઠ �� ������� ����㧪�
      jne No_test
      xchg ah,al
      iret

No_test:
      cmp ah,4Bh     ;�� ����� 䠩��?
      je Start_check
      cmp ah,3Dh     ;�� ����⨥ 䠩��?
      jne No_start

;�������� ᥣ���� � ᬥ饭�� �⥪� ��뢠�饩 �ணࠬ��.
Start_check:
      cli            ;����⨬ ���뢠���
      mov cs:[0],ss  ;���࠭�� ᥣ����� ॣ�����
      mov cs:[2],sp

;��⠭���� �⥪ �� ������� PSP ��襣� १�����
      push cs
      pop ss
      mov sp,0FEh

;���࠭�� �ᯮ��㥬� ॣ�����
      pusha
      pushf
      push es
      push ds

;����ந� ᥣ����� ॣ�����
      push ds
      pop es
      push cs
      pop ds
      sti

; === ��뢠�� ��楤��� �஢�ન ����᪠����� 䠩��... ===
      call Check_prog
;� ��୥��� ⮫쪮 ��᫥ ⮣�, ��� �஢�ਬ 䠩� �, �᫨ ����室���,
;�뫥稬 ���...

;����⠭���� ��࠭���� ॣ�����
      cli
      pop ds
      pop es
      popf
      popa

;����⠭���� ॣ�����, �⢥��騥 �� �⥪
      mov ss,cs:[0]
      mov sp,cs:[2]
      sti

;��।���� �ࠢ����� �ਣ����쭮�� ��ࠡ��稪� 21h-���뢠���
No_start:
      jmp dword ptr cs:[Int_21h_vect]

Int_21h_vect dd ?
Int_21h_proc endp

; === �������� ��楤�� �஢�ન ����᪠����� 䠩�� ===
Check_prog proc
      cld ;���ࠢ����� - ���।!

      mov di,dx ;�饬 � ����� 䠩�� ���
      mov al,'.'
      mov cx,65 ;�ᥣ� �㤥� ��ᬠ�ਢ��� 65 ᨬ�����
Next_sym:
      repne scasb ;�饬 ���� �� ������ ���.
      jne No_com  ;�� ��諨 ��� �����? ����� �� ��室 

;!!! ������ DI 㪠�뢠�� �� ��������� ���� ��᫥ �窨 !!!
      mov ebx,es:[di] ;����ᥬ � EBX ���� ���� ���७�� 䠩�� + 0

      cmp ebx,006D6F63h ;�� 'com'0 ?
      je Got_file       ;��!

      cmp ebx,004D4F43h ;�����, ⮣�� 'COM'0 ?
      jne Next_sym      ;���! �� �뫮 �� ���७�� 䠩��
                        ;(����⭮, ��⠫���)! ��� �� ����� �� com-䠩�?
                        ;���஡㥬 ���� ᫥������ ���... 

; �⠪, ���짮��⥫� ����᪠��/���뢠�� com-䠩�...
Got_file:
      call Check_file ;�஢�ਬ �� ��ࠦ�������...

No_com:
      ret
Check_prog endp

;=== �஢��塞 䠩� �� ��ࠦ������� ===
Check_file proc
      push es ;����ந� ᥣ����� ॣ�����...
      pop ds
      push cs
      pop es
      mov cx,65
      mov si,dx
      mov di,20 ;20-� ���� PSP
      rep movsb ;��७�ᥬ ��� 䠩�� � ��� ᥣ���� � PSP ��� 㤮��⢠...
      push cs
      pop ds

      mov byte ptr cs:[19],4Eh ;��ਡ��� �뢮������ 䠩�� ����� ࠬ��...

      mov ax,3D02h ;��⠥��� ������ �������� com-䠩�...
      mov dx,20    ;��� 䠩�� ⥯��� � ��� � PSP �� ᬥ饭�� 20!
      int 99h
      jc Err_open  ;�訡�� �� ����⨨ (����⭮, ��ਡ��� READ-ONLY)... 

      mov bx,ax
      mov Handle,ax
      mov ah,3Fh
      mov cx,6
      mov dx,10
      int 99h  ;��⠥� ���� ���� ����...
      jc Not_infected ;�訡�� �⥭��!!! 

      mov ah,3Eh ;���஥� 䠩�.
      mov bx,Handle
      int 99h

      cmp byte ptr cs:[10],68h ;���� ���� - 68h (������� PUSH)?
      jne Not_infected         ;��� - ⮣�� 䠩� �� ��ࠦ��! 

      mov eax,dword ptr cs:[12] ;��६ ᫥���騥 �����...
      and eax,0FFFFFF00h ;���㫨� ���� ���� (�� �㤥� ���� ���� ���室�
                         ;�� ��� �室� ����� � ��ࠦ����� 䠩��).
                         ;�.�. ����� 䠩��-����� ࠧ���, � ��� ���� �㤥�
                         ;�ᥣ�� ࠧ��. ��� �⮣� ��, ᮡ�⢥���, �
                         ;���㫨�㥬 ���)...
                         ;� ������ ��砥 �� ⠪ ������ ��� ��������樨
                         ;ࠡ��� 32-� ࠧ�來�� ॣ���஢...
      cmp eax,1122C300h  ;�⠪, �� ��⪠ ��襣� ����� (� ���⭮� ���浪�,
                         ;��祬 ���� ���� ���㫨஢��)?
      jne Not_infected   ;���! ���� ����! 

      call Cure_file     ;���� ��ࠦ�� ��訬 ����ᮬ. ����⭮��� 99,9%.
                         ;��稬 ���...
      ret

Not_infected:
      mov bx,Handle      ;���� �� ��ࠦ�� ��訬 ����ᮬ...
      mov ah,3Eh         ;���஥� ��� � �宭쪮 �멤�� �� ��楤���...
      int 99h
      ret


;�訡�� ������ 䠩��!
Err_open:
;����騬 � ��稢襩�� ���� ���짮��⥫�...
;���� �� ᮮ�饭�� ����, �.�. ��� �㤥� �ᥣ�� ������� �� ����⪥
;������ 䠩� ��� �����, ��ਡ��� ���ண� "Read-only" (���쪮 �⥭��).
      push 1              ;���� ࠬ��
      push 70             ;�ਭ� ࠬ��
      push 4F00h          ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_er ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 19             ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_ErrorOpen  ;ᮮ�饭�� ����� ࠬ��
      push 01b            ;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame     ;���㥬 ࠬ��

      mov ah,10h
      int 16h
      call Restore_scr

;� 㩤�� �� ��楤���. � �� �� ����� ᤥ����, �᫨ 䠩� �� ���뢠����?
;�����, ����筮, ��࠭��� ��ਡ���, �������� ��, ������ 䠩�,
;� ��⮬ ����� ����⠭����� ��ਡ���. �㬠�, �� ��� �஡��� ᤥ���� �� ᠬ�.
      ret

File_size dw ?
Handle dw ?
Check_file endp

include display.asm
; --- ����� ��� 䠩�� Display.asm ---
Height_X equ [bp+12] ;���� ࠬ��
Width_Y  equ [bp+10] ;�ਭ� ࠬ��
Attr     equ [bp+8]  ;��ਡ��� ࠬ��
Mess_up  equ [bp+6]  ;ᮮ�饭�� ������ ࠬ��
Mess_dn  equ [bp+4]  ;ᮮ�饭�� ����� ࠬ��
Mess_ins equ [bp+2]  ;ᮮ�饭�� ����� ࠬ��
Other    equ [bp]    ;���� ���䨣���� ����
Num_DX dw ?
Video_page db 0      ;������ �������࠭��
Pos_cursor dw ?

; === ��稬 ��ࠦ���� 䠩� ===
Cure_file proc
;���ᨬ � ���짮��⥫�, ��� �� �� �뫥��� ��ࠦ���� 䠩�...
      push 1          ;���� ࠬ��
      push 70         ;�ਭ� ࠬ��
      push 4F00h      ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_cr   ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 19         ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_cure  ;ᮮ�饭�� ����� ࠬ��
      push 01b        ;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame ;���㥬 ࠬ��

      mov ah,10h
      int 16h
      call Restore_scr

      cmp al,'y'
      je Cure_f
      cmp al,'Y'
      je Cure_f
      cmp al,13
      je Cure_f

;���, �� ���... � ��࠭��, ��祬�?
      ret

Cure_f:
;���஡㥬 �⢥�� ���� ����� ࠧ��஬ 64��.
      mov ah,48h
      mov bx,4096
      int 99h
      jnc No_error ;��� �訡�� �� �⢮�� ����� 

;�訡��! ����⭮, ��� ������ ����� ���-�... ����騬 ���짮��⥫� �� �⮬...
      push 1     ;���� ࠬ��
      push 70    ;�ਭ� ࠬ��
      push 4F00h ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_er   ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 19    ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_error  ;ᮮ�饭�� ����� ࠬ��
      push 01b   ;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame ;���㥬 ࠬ��

      mov ah,10h
      int 16h
      call Restore_scr

;���஡㥬 �ᯮ�짮���� ������ ����������...
;������� ���������� - � ES
      push 0B900h
      pop es

;� ᮦ������, �� ᬮ��� �뫥��� 䠩�, �ᯮ���� ������ ����������
;(7-� ��࠭��), ࠧ��� ���ண� �� ����� 28669 ����...
      mov Bytes_read,28670
;��稬...
      call Kill_Zarazu
      ret

No_error:
;������� �⢥�� ���� ����� ࠧ��஬ 64��!
;������� �⢥������� ����� - � ES
      push ax
      pop es

      mov Bytes_read,0FFFFh ;= 65535 = 64��
;��稬 䠩�!
      call Kill_Zarazu

;�᢮����� �⢥����� ��襩 �ணࠬ��� ����. ��� ᥣ���� 㦥 � ES.
      mov ah,49h
      int 99h

      ret


Mess_cr db 0CEh, ' ��������! ',0
Mess_cure db 4Bh, '���� ��ࠦ�� ����ᮬ VIRUS20. �뫥��� ��� (Y/N)?',0

Mess_er db 0CEh, ' �訡�� ',0
Mess_Error db 4Bh, '�������筮 ������� ����� ��� ��祭��! ���஡㥬 �����������...',0

Mess_ErrorOpen db 4Bh, '�� 㤠���� ������ 䠩� ��� �⥭��/�����!',0

Mess_Errormem db 4Bh, '���� ����� ����訩 ࠧ���, 祬 �⢥������ ������! ��祭�� ����������!',0

Mess_OKup db 0CEh, ' ���! ',0
Mess_OK db 4Bh, '���� �ᯥ譮 �뫥祭!',0

Cure_file endp

; === ��楤�� ��祭�� 䠩�� ===
Kill_Zarazu proc
      mov ax,3D00h ;���뢠�� 䠩� ��� �⥭��.
      mov dx,20    ;��� 䠩�� �� ᬥ饭�� 20 (�� ��� ��७�᫨).
      int 99h
      mov bx,ax
      mov Handle,ax

      mov cx,Bytes_read ;���쪮 ���� �㤥� ����...
                        ;�᫨ ����稫��� �⢥�� ���� ����� 64 ��, � �⠥�
                        ;���ᨬ� 0FFFFh (65536) ����.
                        ;�᫨ �ᯮ��㥬 ����������, � ���⠥� ���ᨬ�
                        ;�ᥣ� 28670 ����.
      push es           ;��⠥� ���� � ᥣ���� �⢥������� �����,
      pop ds            ;���� � ᥣ���� ����������.
      mov ah,3Fh
      xor dx,dx         ;���饭�� - 0
      int 99h

      push cs
      pop ds

      cmp ax,Bytes_read ;� AX - ������⢮ ���⠭��� ����
                        ;�᫨ AX=Bytes_read, �, ᪮॥ �ᥣ� 䠩� �����
                        ;�⢥������� ࠧ��� ����� (��, ��� ࠢ�� ���).
      jne Ok_size       ;� ⠪�� ��砥 - ᮮ�騬 �� �⮬ ���짮��⥫�...

      push 1     		;���� ࠬ��
      push 70			;�ਭ� ࠬ��
      push 4F00h		;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_er	;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 19			;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_errormem	;ᮮ�饭�� ����� ࠬ��
      push 01b			;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame		;���㥬 ࠬ��

      mov ah,10h
      int 16h
      call Restore_scr

      jmp short Close_file

Ok_size:
      mov File_size,ax ;�������� ������⢮ ॠ�쭮 ���⠭��� ����.

      mov ah,3Eh
      mov bx,Handle
      int 99h

      mov ah,3Ch  ;�������� 䠩� � ⥬ �� ������, �� � ��ࠦ����.
      xor cx,cx   ;��� ������, ��१���襬 ���...
      mov dx,20
      int 99h
      mov Handle,ax

      mov bx,ax
      mov ah,40h       ;����襬 ᯥࢠ ���� ���� ���� 䠩��, �����
      mov dx,File_size ;��� ����� ��࠭�� � 墮��. DX - ����� 䠩��.
      sub dx,6         ;DX=DX-6 - ⥯��� DX 㪠�뢠�� �� ���� ��� ����!
      mov cx,6         ;����襬 6 ����.
      push es          ;������� ������ ���� ����!!!
      pop ds
      int 99h

      push cs
      pop ds

      mov ah,40h       ;������ ����襬 ��⠢����� ���� 䠩��.
      mov dx,6
      mov bx,Handle
      mov cx,File_size ;CX=���-�� ���⠭��� ����.
      sub cx,282       ;CX=CX-282 - ����� ��襣� �����
      push es
      pop ds
      int 99h

      push cs
      pop ds

;����騬 ���짮��⥫� �� �ᯥ譮� �����襭�� ����樨!
      push 1     ;���� ࠬ��
      push 70    ;�ਭ� ࠬ��
      push 4F00h ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_OKup  ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 19    ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_OK  ;ᮮ�饭�� ����� ࠬ��
      push 01b   ;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame ;���㥬 ࠬ��

      mov ah,10h
      int 16h
      call Restore_scr

Close_file:
      mov ah,3Eh
      mov bx,Handle
      int 99h
      ret

Bytes_read dw 0FFFFh
Kill_Zarazu endp




;   === ���樠������ (�����⮢�� � ����ன�� १�����) ===
Init:
      mov ax,0ACDCh ;�஢�ਬ �� ������� ����㧪�.
      int 21h
      cmp ax,0DCACh
      jne Not_inmemory

      mov ah,9
      mov dx,offset Mess_memory
      int 99h

      ret

Not_inmemory:
      mov es,word ptr cs:[2Ch] ;����稬 ᥣ���� ���㦥��� DOS.
      mov ah,49h               ;�㭪�� �᢮�������� �����.
      int 21h                  ;�᢮������� ������...

      mov ax,3521h             ;����稬 ����� 21h-��� ���뢠���
      int 21h
      mov di,offset Int_21h_vect
      mov [di],bx              ; ���࠭�� ��� �
      mov [di+2],es

      mov ax,2599h             ;����� 21h �㤥� �ᯮ�짮���� 99h
      mov dx,bx                ;� ��襬 १�����.
      push es
      pop ds
      int 21h

      push cs
      pop ds

      mov ax,2521h     ;����� �� ����⭮... ���������� �� �㤥�...
      mov dx,offset Int_21h_proc
      int 21h

      mov ah,9
      mov dx,offset Mess_hello
      int 99h

      mov dx,offset Init
      int 27h


;  === ����饭�� ===
Mess_hello db '��⨢���� � ����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 24.',0Ah,0Dh,0Ah
           db '����: ����譨��� ���� ����ᠭ�஢�� (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, �����, ��᪢�, 2001 ���.',0Ah,0Dh,'$'

Mess_memory db '��⨢���� 㦥 ����㦥� � ������ � �ᯥ譮 ࠡ�⠥�!',0Ah,0Dh,'$'

cseg ends
end Begin

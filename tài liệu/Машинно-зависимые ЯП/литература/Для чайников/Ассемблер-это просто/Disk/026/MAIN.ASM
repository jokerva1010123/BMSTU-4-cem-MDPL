;                  === MAIN.ASM - �������� ��楤�� ===

Main_proc proc

      call Hide_cursor ;���祬 �����

      call Prepare_all

      call Save_mainscr ;��࠭�� ᮤ�ন��� ��࠭�...

Re_Read_dir:
      call Draw_main_frame ;���㥬 �������� ࠬ��

      call Get_curdir ;����砥� ⥪�騩 ��⠫��

      call Change_dir ;������ ��� ⥪�騬

      call Get_files  ;��⠥� ��⠫�� � ������

Out_filesl:
      call Out_files ;�뢮��� 䠩�� �� ��࠭

Next_key:
      call Pause
      or al,al
      jz Ext_code  ;�� ���७�� ASCII-��� ������? �� - �஢��塞 ���. 

      cmp al,27    ;������ ESC?
      je Quit_prg  ;��! �� ���� 

      cmp al,13
      je Enter_prsd

      jmp short Next_key

Quit_prg:
      call Quit_prog ;���⢥न� ����७�� ���짮��⥫� ��� �� �ணࠬ��.
      jnc Next_key   ;���짮��⥫� ���⢥न� ��室? ���? ����� �� Next_key 

;��, ���⢥न� (� ����!). ����� ��室��.
      call Restore_mainscr ;����⠭���� ᮤ�ন��� ��࠭�
      call Restore_cursor  ;����⠭���� ������ �����

      ret ;��室�� �� ��楤��� MAIN.ASM, � ��⥬ �ࠧ� � DOS!

Enter_prsd:
      call Enter_pressed
      jmp short Next_key

Ext_code:
      cmp ah,60h         ;������ Ctrl+F3?
      je Re_read_dir     ;�� - �����뢠�� ��⠫�� .

      cmp ah,62h         ;������ Ctrl+F5?
      je User_screenl    ;�� - �����뢠�� ��࠭ ���짮��⥫� .

      cmp ah,50h         ;��५�� ����?
      je Key_down

      cmp ah,48h
      je Key_up

      jmp short Next_key ;��� - ���� ����� ������� 

Key_down:
      call Down_pressed
      jmp Out_filesl

Key_up:
      call Up_pressed
      jmp Out_filesl

User_screenl:
      mov ax,0501h ;�����뢠�� ���짮��⥫� 1 �������࠭���.
      int 10h
      call Pause   ;���� �� �� ���, ���� ���짮��⥫� �� ��������...

      mov ax,0500h ;����� �� �㫥��� ��⠭��������.
      int 10h
      jmp short Next_key ;���� �����... 
Main_proc endp

; === ��⮢�� �� ����室���� ��� ࠡ��� ===
Prepare_all proc
      call Prepare_memory ;�⢮��� ������

      ret
Prepare_all endp

;--- ������� ������ ---
Prepare_memory proc
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h

      mov ah,48h
      mov bx,1000h
      int 21h

      mov Seg_files,ax

      ret
Prepare_memory endp

; === ����砥� ⥪�騩 ���+��⠫�� ===
Get_curdir proc
      mov dword ptr [Current_dir],005C3A43h ;����ᨬ ASCIZ C:\

      mov ah,19h
      int 21h   ;����砥� ⥪�騩 ���
      add al,'A'
      mov byte ptr [Current_dir],al

      ret
Get_curdir endp

; === Change_dir ===
Change_dir proc
      mov ax,713Bh
      mov dx,offset Current_dir
      int 21h

      push 0B800h
      pop es
      mov ah,1Fh
      mov dx,0102h
      mov si,offset Current_dir
      call Print_string

      ret
Change_dir endp


; === ��室�� �� �ணࠬ��? ===
Quit_prog proc
      push 1     ;���� ࠬ��
      push offset Mess_quitl ;�ਭ� ࠬ��
      push 4F00h ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_qup   ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 0     ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_quit  ;ᮮ�饭�� ����� ࠬ��
      push 01b   ;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame ;���㥬 ࠬ��

      call Pause
      call Restore_scr ;����⠭���� ��࠭㭭�� ���� ��࠭�.

      cmp al,'Y'       ;������ 'Y' / 'y' / Enter (13)?
      je Yes_quit      ;��! 
      cmp al,'y'
      je Yes_quit
      cmp al,13
      je Yes_quit

      clc  ;�⠢�� �����, �� ������ ����� ������� (��ᨬ 䫠� ��७��).
      ret

Yes_quit:
      stc  ;��⠭���� 䫠� ��७�� (������ 'Y', ����� ��室��)...
      ret
Quit_prog endp

; === ���㥬 �������� ࠬ�� ===
Draw_main_frame proc
      push 23     ;���� ࠬ��
      push 78     ;�ਭ� ࠬ�� (�.�. �� ���� ��࠭)
      push Main_color ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_head ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_down ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 0      ;ᮮ�饭�� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 10b    ;��࠭ �� ����஢���, �� �뢥�� ������ �����.
      call Draw_frame ;���㥬 ࠬ�� �� ���� ��࠭
      ret
Draw_main_frame endp

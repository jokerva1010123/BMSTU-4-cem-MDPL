;                  === MAIN.ASM - �������� ��楤�� ===

Main_proc proc

      call Hide_cursor ;���祬 �����

      call Prepare_all

      call Save_mainscr ;��࠭�� ᮤ�ন��� ��࠭�...

Re_Read_dir:
;���樠�����㥬 ��६����.
      mov Current_file,0
      mov Start_file,0
      mov Out_fstat,1

      call Draw_main_frame ;���㥬 �������� ࠬ��

      call Get_curdir ;����砥� ⥪�騩 ��⠫��

      call Change_dir ;������ ��� ⥪�騬

      call Get_files  ;��⠥� ��⠫�� � ������

      call Out_files  ;�뢮��� 䠩�� �� ��࠭

Next_key:
      call Pause
      or al,al
      jz Ext_code  ;�� ���७�� ASCII-��� ������? �� - �஢��塞 ���. 

      cmp al,27    ;������ ESC?
      je Quit_prg  ;��! �� ���� 

      cmp al,13    ;������ Enter?
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

      cmp ah,48h         ;��५�� �����?
      je Key_up

      cmp ah,51h         ;������ PageDown?
      je Key_pgd

      cmp ah,49h         ;������ PageUp?
      je Key_pgu

      cmp ah,52h         ;������ Insert?
      je Key_ins

      cmp ah,47h         ;������ Home?
      je Key_home

      cmp ah,4Fh
      je Key_end         ;������ End?

      jmp short Next_key ;��� - ���� ����� ������� 

;��諨 ��楤��� ��ࠡ�⪨ ������� ������...
Key_down:
      call Down_pressed
      jmp Next_key

Key_up:
      call Up_pressed
      jmp Next_key

Key_pgd:
      call PgDown
      jmp Next_key

Key_pgu:
      call PgUp
      jmp Next_key

Key_home:
      call K_home
      jmp Next_key

Key_end:
      call K_end
      jmp Next_key

Key_Ins:
      call Insert
      jmp Next_key

User_screenl:
      mov ax,0501h ;�����뢠�� ���짮��⥫� 1 �������࠭���.
      int 10h
      call Pause   ;���� �� �� ���, ���� ���짮��⥫� �� ��������...

      mov ax,0500h ;����� �� �㫥��� ��⠭��������.
      int 10h
      jmp Next_key ;���� �����... 
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
      int 21h    ;������� ࠧ��� �⢥������ ����� �� ��⪨ Finish

; -- �⢮��� ������ ��� ���뢠��� ��⠫���
;����� ���� ᬥ饭�� �� 䠩��
      mov ah,48h
      mov bx,250 ; 250 * 16 = 4000 ���� = 2000 ��뫮� �� 䠩��
      int 21h
      mov Seg_offset,ax  ;���࠭�� ᥣ����

;����� ���� ᠬ� 䠩��
      mov ah,48h
      mov bx,4096  ;4096 * 16 = 65536 ����
      int 21h
      mov Seg_files,ax    ;���࠭�� ᥣ����
      ret

Seg_offset dw ?
Seg_files dw ?
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
      push 1
      push offset Mess_quitl
      push 4F00h
      push offset Mess_qup
      push 0
      push offset Mess_quit
      push 01b
      call Draw_frame

      call Pause
      call Restore_scr ;����⠭���� ��࠭㭭�� ���� ��࠭�.

      cmp al,'Y'       ;������ 'Y' / 'y' / Enter (13)?
      je Yes_quit      ;��! 
      cmp al,'y'
      je Yes_quit
      cmp al,13
      je Yes_quit

      clc
      ret

Yes_quit:
      stc  ;��⠭���� 䫠� ��७�� (������ 'Y', ����� ��室��)...
      ret
Quit_prog endp

; === ���㥬 �������� ࠬ�� ===
Draw_main_frame proc
      push 23
      push 78
      push Main_color
      push offset Mess_head
      push offset Mess_down
      push 0
      push 10b
      call Draw_frame ;���㥬 ࠬ�� �� ���� ��࠭
      ret
Draw_main_frame endp

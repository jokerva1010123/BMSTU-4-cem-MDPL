
;               ==== ���������� ====

Num_attr db ? ;��६����� ��� ��ਡ�⮢

Num_DX dw ?   ;�६����� ��६����� ��� ��楤��� Draw_frame

Video_page db 0 ;⥪��� �������࠭��

Pos_cursor dw ? ;������� ������ �����


; --- ����� ��� ��楤��� Draw_frame ---
Height_X equ [bp+18] ;���� ࠬ��
Width_Y  equ [bp+16] ;�ਭ� ࠬ��
Attr     equ [bp+14] ;��ਡ��� ࠬ��
Mess_up  equ [bp+12] ;ᮮ�饭�� ������ ࠬ��
Attr_up  equ [bp+10] ;��ਡ��� ᮮ�饭�� ������ ࠬ��
Mess_dn  equ [bp+8]  ;ᮮ�饭�� ����� ࠬ��
Attr_dn  equ [bp+6]  ;��ਡ��� ᮮ�饭�� ����� ࠬ��
Mess_ins equ [bp+4]  ;ᮮ�饭�� ����� ࠬ��
Attr_ins equ [bp+2]  ;��ਡ��� ᮮ�饭�� ����� ࠬ��
Other    equ [bp]    ;���� ���䨣���� ����

; �஢��塞 �� ⥪�⮢� ०�� ������ � �� ⥪���� ����� ��࠭���
Check_video proc
     mov ah,0Fh
     int 10h
     cmp al,3		;����騩 ०�� ������ ⥪�⮢�?
     je Ok_video

     mov ax,3		;�᫨ ��� - ������ ⥪�⮢�
     int 10h

Ok_video:
     cmp bh,0		;�㫥��� ��࠭��?
     jz Ok_page

     mov ax,0500h 	;�᫨ ��� - ������ �㫥��� ⥪�饩
     int 10h

Ok_page:
     ret

Check_video endp

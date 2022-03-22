PUBLIC String, New_line

DataS SEGMENT PARA PUBLIC 'DATA'
    String DB 100 DUP ('$')
    New_line DB 13, 10, '$'
DataS ENDS

END
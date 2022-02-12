CC := gcc
ASM := nasm
FLAGS := -std=c99 -mavx2 -mavx #-masm=intel

SRCS := $(wildcard *.c)
OBJS := $(SRCS:%.c=%.o)


app.exe: 
	gcc -std=gnu11 -masm=intel -mavx -mavx2 -O0 -w -m80387 -c main.c -o main.o
	gcc -std=gnu11 -masm=intel -mavx -mavx2 -O0 -w -m80387 -o app.exe main.o  

	rm -f *.o

app1.exe: 
	gcc -std=gnu11 -masm=intel -mavx -mavx2 -O0 -w -m80387 -c main1.c -o main1.o
	gcc -std=gnu11 -masm=intel -mavx -mavx2 -O0 -w -m80387 -o app1.exe main1.o  

	rm -f *.o


asm:
	gcc -E -mavx2 -mavx main.c -o main.i
	gcc -S -mavx2 -mavx main.i -o main.s
	rm -f *.i

%.o: %.c 
	$(CC) $(FLAGS) -c $< -o $@

clean:
	rm -f *.o *.exe vgcore* *.i
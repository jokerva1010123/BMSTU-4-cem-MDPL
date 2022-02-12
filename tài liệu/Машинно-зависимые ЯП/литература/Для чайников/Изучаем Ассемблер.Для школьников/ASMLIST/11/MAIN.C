/*А.Крупник "Изучаем Accembler"*/
#include <stdio.h>
void xchg(int *a,int *b);
int main(){
int a=2,b=3;
xchg(&a,&b);
printf("a= %d b= %d\n",a,b);
return 0;
}

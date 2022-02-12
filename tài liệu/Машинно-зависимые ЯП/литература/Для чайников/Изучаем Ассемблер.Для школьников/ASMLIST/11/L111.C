/*А.Крупник "Изучаем Ассемблер" листинг 11.1*/
#include <stdio.h>
void xchg(int *a,int *b);
int main(){
int a=2, b=3;
xchg(&a,&b);
printf("a= %d b= %d\n",a,b);
return 0;
}
void xchg(int *a,int *b){
  int tmp;
  tmp=*a;
  *a=*b;
  *b=tmp;
}

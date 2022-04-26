#include <stdio.h>
#include <string.h>


#define N 100

int asm_len(const char *str)
{
    int len = 0;
    const char *copy = str;

    __asm__(
        "mov $0, %%al\n\t" // поместить 0 в al
        "mov %1, %%rdi\n\t" // из первой переменной в rdi
        "mov $0xffffffff, %%ecx\n\t" 
        "repne scasb\n\t" // повторять операцию, пока флаг ZF показывает "не равно или не ноль" 
        // SCASB Сканирование строки байт
        "neg %%ecx\n\t" // инвертируем 
        "dec %%ecx\n\t" // -1
        "mov %%ecx, %0" // передаем то, что получили в 0 переменную
        : "=r"(len) // выходные операнды
        : "r"(copy) // входные операнды
        // то есть переменная copy разместиться в каком-то регистре общего назначения
        // (задано символом r), перед выполнением кода вставки
        : "%ecx", "%rdi", "%al"
    );
    return len - 1;
}

void strcopy(char *dest, char *src, int len);

void tests_for_strlen()
{
    char s[] = "12345abc";
    printf("String for test: \"%s\"\nAsm_len = %d\nStrlen = %ld\n", s, asm_len(s), strlen(s));
    
    char s1[10] = "1";
    printf("String for test: \"%s\"\nAsm_len = %d\nStrlen = %ld\n", s1, asm_len(s1), strlen(s1));
}

void tests_for_strcopy()
{
    char sourse[15] = "abcdefghijkl";
    char destination[N] = "0123456789";
    char std_sourse[15] = "abcdefghijkl";
    char std_destination[N] = "0123456789";
    int len = 0;
    strcopy(sourse + 3, sourse, 9);
    printf("Result: %s\n", sourse);
    memmove(std_sourse + 3, std_sourse, 9);
    printf("Library:%s\n", std_sourse);

    strcopy(sourse, sourse+3, 9);
    printf("Result: %s\n", sourse);
    memmove(std_sourse, std_sourse+3, 9);
    printf("Library:%s\n", std_sourse);
}

int main()
{
    printf("TESTS FOR LEN!!!\n");
    tests_for_strlen();
    printf("\nTESTS FOR COPY!!!\n");
    tests_for_strcopy();
}
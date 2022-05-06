#include "for_80.h"
#include "my_main.h"
#include <time.h>

void sum_float80(__float80 a, __float80 b)
{
    __float80 res;
    for (int i = 0; i < 10000; i++)
        res = a + b;
}

void mult_float80(__float80 a, __float80 b)
{
    __float80 res;
    for (int i = 0; i < 10000; i++)
        res = a * b;
}

void sum_float80_asm(__float80 a, __float80 b)
{
    __float80 res;
     for (int i = 0; i < 10000; i++)
        __asm__(
            "fld %2\n\t"
            "fld %1\n\t"

            "faddp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}

void mult_float80_asm(__float80 a, __float80 b)
{
    __float80 res;
    for (int i = 0; i < 10000; i++)
         __asm__(
            "fld %2\n\t"
            "fld %1\n\t"

            "fmulp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}

void time_test_float80()
{
    __float80 a = 1.23, b = 4.56;
    printf("80 bit tests: \n");

    clock_t start = clock();
    sum_float80(a, b);
    clock_t end = clock();
    printf("Sum test: %lf\n", 1.0*(end - start)/10000);

    start = clock();
    mult_float80(a, b);
    end = clock();
    printf("Mult test: %lf\n", 1.0*(end - start)/10000);   

    start = clock();
    sum_float80_asm(a, b);
    end = clock();
    printf("Sum_asm test: %lf\n", 1.0*(end - start)/10000);

    start = clock();
    mult_float80_asm(a, b);
    end = clock();
    printf("Mult_asm test: %lf\n", 1.0*(end - start)/10000);  
}
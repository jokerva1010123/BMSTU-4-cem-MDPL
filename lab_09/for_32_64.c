#include "for_32_64.h"
#include "my_main.h"

#define N 1000000000

void sum_float(float a, float b)
{
    float res;
    for (int i = 0; i < N; i++)
        res = a + b;
}

void mult_float(float a, float b)
{
    float res;
    for (int i = 0; i < N; i++)
        res = a * b;
}

void sum_double(double a, double b)
{
    double res;
    for (int i = 0; i < N; i++)
        res = a + b;
}

void mult_double(double a, double b)
{
    double res;
    for (int i = 0; i < N; i++)
        res = a * b;
}

void sum_float_asm(float a, float b)
{
    float res;
    for (int i = 0; i < N; i++)
         __asm__ __volatile__(
            "fld %2\n\t"
            "fld %1\n\t"

            "faddp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}

void mult_float_asm(float a, float b)
{
    float res;
    for (int i = 0; i < N; i++)
        __asm__ __volatile__(
            "fld %2\n\t"
            "fld %1\n\t"

            "fmulp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}


void sum_double_asm(double a, double b)
{
    double res;
    for (int i = 0; i < N; i++)
        __asm__ __volatile__(
            "fld %2\n\t"
            "fld %1\n\t"

            "faddp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}

void mult_double_asm(double a, double b)
{
    double res;
    for (int i = 0; i < N; i++)
        __asm__ __volatile__(
            "fld %2\n\t"
            "fld %1\n\t"

            "fmulp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}


void time_test_float()
{
    float a = 1.23, b = 4.56;
    printf("\n\n%lf bit tests: \n", sizeof(float) * CHAR_BIT);

    int start = clock();
    sum_float(a, b);
    int end = clock();
    printf("Sum test: %lf\n", 1.0*(end - start)/N);

    start = clock();
    mult_float(a, b);
    end = clock();
    printf("Mult test: %lf\n\n\n", 1.0*(end - start)/N);  

    start = clock();
    sum_float_asm(a, b);
    end = clock();
    printf("Sum_asm test: %lf\n", 1.0*(end - start)/N);

    start = clock();
    mult_float_asm(a, b);
    end = clock();
    printf("Mult_asm test: %lf\n\n\n", 1.0*(end - start)/N);
}

void time_test_double()
{
    float a = 1.23, b = 4.56;
    printf("\n\n%lf bit tests: \n", sizeof(double) * CHAR_BIT);

    int start = clock();
    sum_double(a, b);
    int end = clock();
    printf("Sum test: %lf\n", 1.0*(end - start)/N);

    start = clock();
    mult_double(a, b);
    end = clock();
    printf("Mult test: %lf\n\n\n", 1.0*(end - start)/N);   


    start = clock();
    sum_double_asm(a, b);
    end = clock();
    printf("Sum_asm test: %lf\n", 1.0*(end - start)/N);

    start = clock();
    mult_double_asm(a, b);
    end = clock();
    printf("Mult_asm test: %lf\n\n\n", 1.0*(end - start)/N); 
}

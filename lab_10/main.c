#include <limits.h>
#include <time.h>
#include <stdio.h>
#define N_REPEATS 100000
#define ND 4

void count_scalar_product_c(double* a, double* b)
{
    double c;
    for (size_t i = 0; i < N_REPEATS; i++)
    {
        c = 0;
        for (size_t j = 0; j < ND; j++)
            c += a[j] * b[j];
    }
    printf("Result use C: %0.3lf\n", c);
}

void count_scalar_product_asm(double *a, double *b)
{
    double c;
    double(*ptr_a)[ND] = a;
    double(*ptr_b)[ND] = b;
    for (size_t i = 0; i < N_REPEATS; i++)
    {
        {
            asm volatile(
                "vmovupd ymm0, %1\n"
                "vmovupd ymm1, %2\n"
                "vmulpd ymm0, ymm0, ymm1\n"             
                "vhaddpd ymm1, ymm0, ymm0\n"     
                "vextractf128 xmm0, ymm1, 1\n"
                "vaddpd ymm0, ymm1, ymm0\n"
                "movlpd %0, xmm0\n"
                :
                : "m"(c), "m"(*ptr_a), "m"(*ptr_b)
                : "ymm0", "ymm1", "memory");
        }
    }
    printf("Result use ASM: %0.3lf\n", c);
}

int main(void)
{
    printf("Counted scalar product for %dd-vectors of double %d times\n", ND, N_REPEATS);
    double a[ND] = { 0, 1, 2, 3};
    double b[ND] = { 0, 1, 2, 3};

    clock_t begin = clock();
    count_scalar_product_c(a, b);
    clock_t end = clock();
    printf("Using code in C: %.8lf sec\n", (double)(end - begin) / (CLOCKS_PER_SEC));

    begin = clock();
    count_scalar_product_asm(a, b);
    end = clock();
    printf("Using code in ASM: %.8lf sec\n", (double)(end - begin) / (CLOCKS_PER_SEC));

    return 0;
}
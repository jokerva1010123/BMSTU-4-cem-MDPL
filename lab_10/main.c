#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define OK 0
#define N 3

void vec_mult_asm(double *res, const double *a, const double *b, int n)
{
    for (const double *a_end = a + n - 1; a <= a_end; a += 1, b += 1)
    {
        asm(
            "vmovsd xmm0, %1\n"
            "vmovsd xmm1, %2\n"
            "vmulpd xmm0, xmm0, xmm1\n"

            "vaddpd xmm3, xmm3, xmm0\n"
            "movupd xmmword ptr [%0], xmm3\n"
            :
            : "r"(res), "m"(*a), "m"(*b)
            : "xmm0", "xmm1");
    }
}

void vec_mult_c(double *res, const double *a, const double *b, int n)
{
    for (int i = 0; i < n; i++)
    {
        *res += a[i] * b[i]; 
    }
}

int main(int argc, char * argv[])
{
    double a[N] = {1.1, 2.2, 3.3};
    double b[N] = {4.4, 5.5, 6.6};

    double res = 0;

    int start = clock();
    for (int i = 0; i < 10000; i++)
    {
        res = 0;
        vec_mult_c(&res, a, b, N);
    }
    int end = clock();

    printf("\nScalar C: %ld\n", end - start);

    start = clock();
    for (int i = 0; i < 10000; i++)
    {
        res = 0;
        vec_mult_asm(&res, a, b, N);
    }
    end = clock();

    printf("Scalar ASM: %ld\n\n", end - start);

    return 0;
}
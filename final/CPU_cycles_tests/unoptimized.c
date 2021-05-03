/*
 This probes the most unoptimized version of the matmul.
 */

#include<stdio.h> 
#include<stdlib.h>
#include<linux/types.h>

#define TIMES 100
#define SIZE 1024

__u64 rdtsc()
{
        __u32 lo,hi;

        __asm__ __volatile__
        (
         "rdtsc":"=a"(lo),"=d"(hi)
        );
        return (__u64)hi<<32|lo;
}

int test_rdtsc()
{
        __u64 begin;
        __u64 end;
        
        int kernel_size = 25;
        int numrows = 4704;
        int weight[numrows][kernel_size];
        int input[numrows][kernel_size];
        int output[numrows];
        
        for (int j=0; j< numrows; j++) {
            for (int k=0;k<kernel_size; k++) {
                int tmp = rand()%200;
                if (tmp>99) {
                    weight[j][k] = 1;
                } else {
                    weight[j][k] = -1;
                }
            }
        }
        for (int j=0; j< numrows; j++) {
            for (int k=0;k<kernel_size; k++) {
                int tmp = rand()%200;
                if (tmp>99) {
                    input[j][k] = 1;
                } else {
                    input[j][k] = -1;
                }
            }
        }
        
        begin = rdtsc();
        for (int j=0; j< numrows; j++) {
            int tmp = 0;
            for (int k=0;k<kernel_size; k++) {
                tmp += weight[j][k] * input[j][k];
            }
            output[j] = tmp;
        }
        
        end = rdtsc();
        printf("The function cost %llu CPU cycles\n",end-begin);
        return 0;
}

int main()
{
       test_rdtsc();
        return 0;
}



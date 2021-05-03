/*
 This a version assume the data is prepared as the accelerator.
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
        int weight[numrows];
        int input[numrows];
        int output[numrows];
        
        for (int j=0; j< numrows; j++) {
            weight[j] = rand();
            input[j] = rand();
        }
        
        begin = rdtsc();
        for (int j=0; j< numrows; j++) {
            int tmp = ~(weight[j]^input[j]);
            // assume there's an efficient bitcount in the CPU, this is just a place holder.
            int sum = (tmp & tmp);
            output[j] = sum - kernel_size;
            
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

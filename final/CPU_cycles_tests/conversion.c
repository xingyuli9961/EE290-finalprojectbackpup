/*
 This simulates the process of pre-proces the data.
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
        int input[numrows][kernel_size];
        int output[numrows];
        
        
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
            tmp = tmp & (input[j][24] >> 31);
            tmp = (tmp<<1) & (input[j][23] >> 31);
            tmp = (tmp<<1) & (input[j][22] >> 31);
            tmp = (tmp<<1) & (input[j][21] >> 31);
            tmp = (tmp<<1) & (input[j][20] >> 31);
            tmp = (tmp<<1) & (input[j][19] >> 31);
            tmp = (tmp<<1) & (input[j][18] >> 31);
            tmp = (tmp<<1) & (input[j][17] >> 31);
            tmp = (tmp<<1) & (input[j][16] >> 31);
            tmp = (tmp<<1) & (input[j][15] >> 31);
            tmp = (tmp<<1) & (input[j][14] >> 31);
            tmp = (tmp<<1) & (input[j][13] >> 31);
            tmp = (tmp<<1) & (input[j][12] >> 31);
            tmp = (tmp<<1) & (input[j][11] >> 31);
            tmp = (tmp<<1) & (input[j][10] >> 31);
            tmp = (tmp<<1) & (input[j][9] >> 31);
            tmp = (tmp<<1) & (input[j][8] >> 31);
            tmp = (tmp<<1) & (input[j][7] >> 31);
            tmp = (tmp<<1) & (input[j][6] >> 31);
            tmp = (tmp<<1) & (input[j][5] >> 31);
            tmp = (tmp<<1) & (input[j][4] >> 31);
            tmp = (tmp<<1) & (input[j][3] >> 31);
            tmp = (tmp<<1) & (input[j][2] >> 31);
            tmp = (tmp<<1) & (input[j][1] >> 31);
            tmp = (tmp<<1) & (input[j][0] >> 31);
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


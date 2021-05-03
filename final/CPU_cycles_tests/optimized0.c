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
            tmp += weight[j][0] * input[j][0];
            tmp += weight[j][1] * input[j][1];
            tmp += weight[j][2] * input[j][2];
            tmp += weight[j][3] * input[j][3];
            tmp += weight[j][4] * input[j][4];
            tmp += weight[j][5] * input[j][5];
            tmp += weight[j][6] * input[j][6];
            tmp += weight[j][7] * input[j][7];
            tmp += weight[j][8] * input[j][8];
            tmp += weight[j][9] * input[j][9];
            tmp += weight[j][10] * input[j][10];
            tmp += weight[j][11] * input[j][11];
            tmp += weight[j][12] * input[j][12];
            tmp += weight[j][13] * input[j][13];
            tmp += weight[j][14] * input[j][14];
            tmp += weight[j][15] * input[j][15];
            tmp += weight[j][16] * input[j][16];
            tmp += weight[j][17] * input[j][17];
            tmp += weight[j][18] * input[j][18];
            tmp += weight[j][19] * input[j][19];
            tmp += weight[j][20] * input[j][20];
            tmp += weight[j][21] * input[j][21];
            tmp += weight[j][22] * input[j][22];
            tmp += weight[j][23] * input[j][23];
            tmp += weight[j][24] * input[j][24];
            
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

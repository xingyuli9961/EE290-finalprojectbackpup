/*
 This file contains loop unrolling.
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
        for (int j=0; j< numrows; j = j + 4) {
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
            
            int tmp1 = 0;
            tmp1 += weight[j+1][0] * input[j+1][0];
            tmp1 += weight[j+1][1] * input[j+1][1];
            tmp1 += weight[j+1][2] * input[j+1][2];
            tmp1 += weight[j+1][3] * input[j+1][3];
            tmp1 += weight[j+1][4] * input[j+1][4];
            tmp1 += weight[j+1][5] * input[j+1][5];
            tmp1 += weight[j+1][6] * input[j+1][6];
            tmp1 += weight[j+1][7] * input[j+1][7];
            tmp1 += weight[j+1][8] * input[j+1][8];
            tmp1 += weight[j+1][9] * input[j+1][9];
            tmp1 += weight[j+1][10] * input[j+1][10];
            tmp1 += weight[j+1][11] * input[j+1][11];
            tmp1 += weight[j+1][12] * input[j+1][12];
            tmp1 += weight[j+1][13] * input[j+1][13];
            tmp1 += weight[j+1][14] * input[j+1][14];
            tmp1 += weight[j+1][15] * input[j+1][15];
            tmp1 += weight[j+1][16] * input[j+1][16];
            tmp1 += weight[j+1][17] * input[j+1][17];
            tmp1 += weight[j+1][18] * input[j+1][18];
            tmp1 += weight[j+1][19] * input[j+1][19];
            tmp1 += weight[j+1][20] * input[j+1][20];
            tmp1 += weight[j+1][21] * input[j+1][21];
            tmp1 += weight[j+1][22] * input[j+1][22];
            tmp1 += weight[j+1][23] * input[j+1][23];
            tmp1 += weight[j+1][24] * input[j+1][24];
            
            output[j+1] = tmp1;
            
            int tmp2 = 0;
            tmp2 += weight[j+2][0] * input[j+2][0];
            tmp2 += weight[j+2][1] * input[j+2][1];
            tmp2 += weight[j+2][2] * input[j+2][2];
            tmp2 += weight[j+2][3] * input[j+2][3];
            tmp2 += weight[j+2][4] * input[j+2][4];
            tmp2 += weight[j+2][5] * input[j+2][5];
            tmp2 += weight[j+2][6] * input[j+2][6];
            tmp2 += weight[j+2][7] * input[j+2][7];
            tmp2 += weight[j+2][8] * input[j+2][8];
            tmp2 += weight[j+2][9] * input[j+2][9];
            tmp2 += weight[j+2][10] * input[j+2][10];
            tmp2 += weight[j+2][11] * input[j+2][11];
            tmp2 += weight[j+2][12] * input[j+2][12];
            tmp2 += weight[j+2][13] * input[j+2][13];
            tmp2 += weight[j+2][14] * input[j+2][14];
            tmp2 += weight[j+2][15] * input[j+2][15];
            tmp2 += weight[j+2][16] * input[j+2][16];
            tmp2 += weight[j+2][17] * input[j+2][17];
            tmp2 += weight[j+2][18] * input[j+2][18];
            tmp2 += weight[j+2][19] * input[j+2][19];
            tmp2 += weight[j+2][20] * input[j+2][20];
            tmp2 += weight[j+2][21] * input[j+2][21];
            tmp2 += weight[j+2][22] * input[j+2][22];
            tmp2 += weight[j+2][23] * input[j+2][23];
            tmp2 += weight[j+2][24] * input[j+2][24];
            
            output[j+2] = tmp2;
            
            int tmp3 = 0;
            tmp3 += weight[j+3][0] * input[j+3][0];
            tmp3 += weight[j+3][1] * input[j+3][1];
            tmp3 += weight[j+3][2] * input[j+3][2];
            tmp3 += weight[j+3][3] * input[j+3][3];
            tmp3 += weight[j+3][4] * input[j+3][4];
            tmp3 += weight[j+3][5] * input[j+3][5];
            tmp3 += weight[j+3][6] * input[j+3][6];
            tmp3 += weight[j+3][7] * input[j+3][7];
            tmp3 += weight[j+3][8] * input[j+3][8];
            tmp3 += weight[j+3][9] * input[j+3][9];
            tmp3 += weight[j+3][10] * input[j+3][10];
            tmp3 += weight[j+3][11] * input[j+3][11];
            tmp3 += weight[j+3][12] * input[j+3][12];
            tmp3 += weight[j+3][13] * input[j+3][13];
            tmp3 += weight[j+3][14] * input[j+3][14];
            tmp3 += weight[j+3][15] * input[j+3][15];
            tmp3 += weight[j+3][16] * input[j+3][16];
            tmp3 += weight[j+3][17] * input[j+3][17];
            tmp3 += weight[j+3][18] * input[j+3][18];
            tmp3 += weight[j+3][19] * input[j+3][19];
            tmp3 += weight[j+3][20] * input[j+3][20];
            tmp3 += weight[j+3][21] * input[j+3][21];
            tmp3 += weight[j+3][22] * input[j+3][22];
            tmp3 += weight[j+3][23] * input[j+3][23];
            tmp3 += weight[j+3][24] * input[j+3][24];
            
            output[j+3] = tmp3;
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



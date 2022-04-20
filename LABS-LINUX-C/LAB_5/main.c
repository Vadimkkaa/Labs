#include <pthread.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define     MAX_THREADS_COUNT   8
#define     IN_FILE_NAME        "sample.bmp"
#define     PROGRAM_OUT_FILE    "program.bmp"
#define     THREADS_OUT_FILE    "threads.bmp" 

FILE *file_in;
FILE *file_out_th;
FILE *file_out;

int size;

typedef struct
{
    pthread_t id;
    int number;
    unsigned char **pix;
    int *res;
} thread_data;

void no_thread_routine();

void *thread_routine(void *thread_data);

void *thread_routine(void *args)
{
    thread_data *data = (thread_data*)args;
    for (int i = 0; i < size / MAX_THREADS_COUNT; i++) // RGB to gray
    {
        data->res[i] = (data->pix[i][0] * 0.3) + (data->pix[i][1] * 0.59) + (data->pix[i][2] * 0.11);
    }
    pthread_exit(0);
}

int main()
{
    clock_t start, stop;

    start = clock();

    FILE *file_in = fopen(IN_FILE_NAME, "rb");
    FILE *file_out_thread = fopen(THREADS_OUT_FILE, "wb");
    
    unsigned char byte[54];

    if (file_in == NULL || file_out_thread == NULL)
    {
        printf("Error opening file!\n");
    }

    fread(byte, sizeof(unsigned char), 54, file_in);
    fwrite(byte, sizeof(unsigned char), 54, file_out_thread);

    int height = *(int*)&byte[18];
    int width = *(int*)&byte[22];

    size = height * width;              

    thread_data info[MAX_THREADS_COUNT];

    for (int i = 0; i < MAX_THREADS_COUNT; i++) 
    {
        info[i].res = (int *)malloc((size / MAX_THREADS_COUNT) * sizeof(int));
        info[i].pix = (unsigned char **)malloc((size / MAX_THREADS_COUNT) * sizeof(unsigned char *));

        for (int j = 0; j < size / MAX_THREADS_COUNT; j++)
        {
            info[i].pix[j] = (unsigned char *)malloc(3 * sizeof(unsigned char));
            info[i].pix[j][2] = getc(file_in); 
            info[i].pix[j][1] = getc(file_in); 
            info[i].pix[j][0] = getc(file_in); 
        }
    }

    for (int i = 0; i < MAX_THREADS_COUNT; i++)
    {
        info[i].number = i;
        int status = pthread_create(&(info[i].id), NULL, &thread_routine, &info[i]);
        if (status != 0)
        {
            printf("ERROR: pthread_create\n");
            exit(0);
        }
    }

    for (int i = 0; i < MAX_THREADS_COUNT; i++)
    {
        pthread_join(info[i].id, NULL);
    }

    for (int i = 0; i < MAX_THREADS_COUNT; i++) // RGB to gray
    {
        for (int j = 0; j < (size / MAX_THREADS_COUNT); j++)
        {
            putc(info[i].res[j], file_out_thread);
            putc(info[i].res[j], file_out_thread);
            putc(info[i].res[j], file_out_thread);
        }
    }

    fclose(file_out_thread);
    fclose(file_in);

    stop = clock();
    printf("Using threads took: %lf ms\n", ((double)(stop - start) * 1000.0) / CLOCKS_PER_SEC);

    no_thread_routine();
    exit(0);
}

void no_thread_routine()
{
    file_in  = fopen(IN_FILE_NAME, "rb");
    file_out = fopen(PROGRAM_OUT_FILE, "wb");

    clock_t start, stop;
    start = clock();

    unsigned char header[54];

    fread(header, sizeof(unsigned char), 54, file_in);
    fwrite(header, sizeof(unsigned char), 54, file_out); 

    int height = *(int *)&header[18];
    int width = *(int *)&header[22];

    size = height * width; // calculate image size

    int *res = (int *)malloc(size * sizeof(int));

    unsigned char **pix = (unsigned char **)malloc(size * sizeof(unsigned char *));

    for (int i = 0; i < size; i++) // RGB to gray
    {
        pix[i] = (unsigned char *)malloc(3 * sizeof(unsigned char));
    }

    for (int j = 0; j < size; j++)
    {
        pix[j][2] = getc(file_in); // blue
        pix[j][1] = getc(file_in); // green
        pix[j][0] = getc(file_in); // red
    }

    for (int i = 0; i < size; i++) // RGB to gray
    {
        res[i] = (pix[i][0] * 0.3) + (pix[i][1] * 0.59) + (pix[i][2] * 0.11);
    }

    for (int i = 0; i < size; i++)
    {
        putc(res[i], file_out);
        putc(res[i], file_out);
        putc(res[i], file_out);
    }

    fclose(file_out);
    fclose(file_in);

    stop = clock();
    printf("Without threads took: %lf ms\n", ((double)(stop - start) * 1000.0) / CLOCKS_PER_SEC);

    return;
}
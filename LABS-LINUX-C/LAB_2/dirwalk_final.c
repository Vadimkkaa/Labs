#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>
#include <assert.h>

#define NO_KEYS 0
#define LINKS 1
#define DIRECTORIES 2
#define FILES 3
#define SORT 4
#define WE_HAVE_STH 5



void handle_task() {


}
int cmp(const void* a, const void *b) 
{
    assert(a && b);
    return strcoll(*(char**)a, *(char**)b);
}

int count_dir(char* path)

{
    DIR* dirPtr = opendir(path);

    if (dirPtr == NULL) {
        return 0;
    }
    struct dirent* item;

    int count = 0;

    while ((item = readdir(dirPtr)) != NULL) {
        if (strcmp(item->d_name, ".") != 0 
        && strcmp(item->d_name, "..") != 0) {
            count++;
        }
    }
    closedir(dirPtr);
    return count;
}
void sort(char** names, int size)
{
    qsort(names, size, sizeof(char*), cmp);
}

int main(int argc, char* argv[]) {
    int index=0;

    int keys_meaning; //to understand whether we have key:-d,-l,-f,-s or no keys at all

    DIR* dir=opendir(".");
    struct  dirent* sd;


    int dir_count = 1;
    char** dir_names = NULL;

    dir_names=(char**)calloc(sizeof(char*), 1);

    int size = count_dir(dir);
    rewinddir(dir);
    if (dir == NULL) {
        printf("Error.Can't open the directory :(\n");
        return -1;
    }

    if (argc == 1)
        keys_meaning = NO_KEYS;
    else keys_meaning=WE_HAVE_STH;

   // char* string;

    for (int i = 1; i < argc; i++) {
       char* string = (char*)malloc(strlen(argv[i])+1 * sizeof(char));
       string[strlen(argv[i])+1]='\0';

        strcpy(string, argv[i]);
        if (string[0] == '-') {
            int num = 1;
            while (string[num] != '\0') {
                switch (string[num]) {
                case 'l': {

                    while ((sd = readdir(dir)) != NULL) {
                        if( sd->d_type==DT_LNK){
                             dir_names=(char**)realloc(dir_names,dir_count*sizeof(char*));
                             dir_names[index] = (char*)calloc(sizeof(char), strlen(sd->d_name) + 1);
                            strcat(dir_names[index++], sd->d_name);
                            dir_count++;
                        }

                    }
                    rewinddir(dir);
                    break;
                }
                case 'd': {
                     while ((sd = readdir(dir)) != NULL) {
                        if( sd->d_type==DT_DIR){
                            dir_names=(char**)realloc(dir_names,dir_count*sizeof(char*));
                             dir_names[index] = (char*)calloc(sizeof(char), strlen(sd->d_name) + 1);
                            strcat(dir_names[index++], sd->d_name);
                            dir_count++;
                        }
         
                    }
                    rewinddir(dir);
                    break;
                }
                case 'f': {
                    while ((sd = readdir(dir)) != NULL) {
                          if( sd->d_type==DT_REG){
                               dir_names=(char**)realloc(dir_names,dir_count*sizeof(char*));
                             dir_names[index] = (char*)calloc(sizeof(char), strlen(sd->d_name) + 1);
                            strcat(dir_names[index++], sd->d_name);
                            dir_count++;
                          }
                   
                    }
                    rewinddir(dir);
                    break;
                }
                case 's': {
                        if(keys_meaning==NO_KEYS){
                           printf("No keys entered!!\n");
                           return 0;
                        }
                  
                 sort(dir_names, --dir_count);
                   
                    keys_meaning == WE_HAVE_STH;
                    rewinddir(dir);
                    break;
                }
                default:
	                {
                       printf("Wrong keys entered!!\n");
	                }

                }
                num++;   
            }
                
            }
              free(string);
        }
       
        if( keys_meaning == NO_KEYS)
        {
             while ((sd = readdir(dir)) != NULL) 
               printf(">> %s\n", sd->d_name);
             
             return 0;
        }
 
        if( keys_meaning == WE_HAVE_STH)
        {
           for(int i=0;i<dir_count-1;i++)
                 printf(">> %s\n",dir_names[i]);
             return 0;
        }
 
 
    closedir(dir);
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void print_argc(int argc,char*argv[]){

     fprintf(stdout,"Arguments:\n");

     for(int i=0;i<argc;i++){
         fprintf(stdout,"%s\n",argv[i]);
     }

}

int main(int argc,char *argv[]){

    fprintf(stdout, "Child process is running..\n");
    fprintf(stdout, "Child process pid: %d\n", getpid());
    fprintf(stdout, "Child process ppid: %d\n\n", getppid());

    print_argc(argc,argv);
    exit(0);
}
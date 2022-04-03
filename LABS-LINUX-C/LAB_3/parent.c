#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>

int main(){
    int child_status;


    fprintf(stdout,"Parent process started..\n");
    fprintf(stdout,"Parent process PID: %d\n\n",getpid());

    char *argc[]={"Process","Definitely","Started",(char*)0};

    pid_t child_pid=fork();

    switch (child_pid){

        case -1:{
            fprintf(stdout,"Child process was not created!\n");
            fprintf(stdout,"Error code: %d\n",errno);
            exit(errno);
            break;
        }

        case 0:{
            fprintf(stdout,"Child process created!\n");
            execve("./child",argc,NULL);
            break;
        }
    
    }

    wait(&child_status);

    fprintf(stdout,"\n");
    fprintf(stdout,"Child process has ended with %d status\n",child_status);
    exit(0);
}
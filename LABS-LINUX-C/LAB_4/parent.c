#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <errno.h>

void parse_input(char *input, char *action, int *param)
{
    *action = input[0];
    *param = 0;

    int i = 0;
    int is_number_parsed = 0;
    while (input[i++]) {
        if (!isdigit(input[i])) {
            i++;
            continue;
        }
        is_number_parsed = 1;
        *param = 10 * *param + input[i] - '0';
    }
    if (!is_number_parsed) {
        *param = -1;
    }
}

int main()
{
    char input[20];
    pid_t pids[999];
    int number = -1;
    char option = 0;

    int i = 0;
    
    while (1) {
        scanf("%s", &input);
        parse_input(input, &option, &number);
            
        if (option == '+') {
            system("clear");
            pids[i] = fork();
            if (pids[i] < 0) {
                exit(1);
            } else if (pids[i] == 0) {
                if(execl("child", NULL, NULL) == -1){
                    printf("Error using execl\n");
                    exit(-1);
                }
            }
            printf("Process created!\n");
            i++;
        } else if (option == '-') {
            system("clear");
            if (i == 0) {
                printf("There are no created processes\n");
            } else {
                printf("Process %d deleted, %d processes left\n", i, i - 1);
                i--;
                kill(pids[i], SIGTERM);
          
            }
        } else if (option == 'k') {
            system("clear");
            while (i != 0) {
                kill(pids[i - 1], SIGTERM);
                printf("Process %d deleted\n", i);
                i--;
            }
            printf("All processes deleted\n");
        } else if (option == 's' && number == -1) {
            system("clear");
            for (int j = 0; j < i; j++) {
                kill(pids[j], SIGSTOP);
            }
            printf("Output denied for all processes!\n");
        } else if (option == 'g' && number == -1) {
            system("clear");
            for (int j = 0; j < i; j++) {
                kill(pids[j], SIGCONT);
            }
            printf("Output allowed for all processes!\n");
        } else if (option == 'g' && number != -1) {
            system("clear");
            if (number > i || number < 0) {
                printf("There's no such process\n");
            } else {
                kill(pids[number], SIGCONT);
                printf("Output allowed for %d process!\n", number);
            }
         } else if (option == 's' && number != -1) {
            system("clear");
            if (number > i || number < 0) {
                printf("There's no such process\n");
            } else {
                kill(pids[number], SIGSTOP);
                printf("Output denied for %d process!\n", number);
            }
        } else if (option == 'p' && number != -1) {
            system("clear");
            if (number > i || number < 0) {
                printf("There's no such process\n");
                continue;
            } 
            for (int j = 0; j < i; j++) {
                kill(pids[j], SIGSTOP);
            }
            kill(pids[number], SIGCONT);
        } else if (option == 'q') {
            system("clear");
            while (i != 0) {
                kill(pids[i - 1], SIGTERM);
                i--;
            }
            break;
        } else {
            printf("No such option\n");
        }
    }
    exit(0);
}
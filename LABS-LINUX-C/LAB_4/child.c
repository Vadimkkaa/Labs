#include <signal.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>

static int counts[] = { 0, 0, 0, 0 };

struct child { 
    
    int a, b; 

} child_struct;

void status()
{
    printf("[PID: %d, PPID: %d, [00]: %d, [01]: %d, [10]: %d, [11]: %d]\n", 
        (int)getpid(), (int)getppid(), counts[0], counts[1], counts[2], counts[3]);
    alarm(5);
}

void calculate_stats() 
{
    if (child_struct.a == 0 && child_struct.b == 0) {
        counts[0]++;
    } else if (child_struct.a == 0 && child_struct.b == 1) {
        counts[1]++;
    } else if (child_struct.a == 1 && child_struct.b == 0) {
        counts[2]++;
    } else if (child_struct.a == 1 && child_struct.b == 1) {
        counts[3]++;
    }
}

void handle_signal(int sig)
{
    if (sig == SIGALRM) {
        calculate_stats();
        status();
    }
}

int main(void)
{
    static struct child zeros = {0, 0}, one_zero = {0, 1}, zero_one = {1, 0}, ones = {1, 1};
    struct sigaction signal_struct;

    signal_struct.sa_handler = handle_signal;
    sigemptyset(&signal_struct.sa_mask);
    signal_struct.sa_flags = 0;
    
    if (sigaction(SIGALRM, &signal_struct, NULL) == -1) {
        perror("CHILD: Error in sigaction (SIGALRM)!\n");
        exit(errno);
    }

    alarm(5);
    while (1) {      
        child_struct = zeros;
        child_struct = one_zero;
        child_struct = zero_one;
        child_struct = ones;
    }
    
    exit(0);
}
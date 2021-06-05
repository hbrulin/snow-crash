#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int ac, char **av)
{
    int fd;
    char p[50];

    fd = open(av[1], O_RDONLY);
    read(fd, p, 50);
    close(fd);
    puts(p);
    int i = 0;
    while (i < strlen(p))
    {
        p[i] = p[i] - i;
        i++;
    }
    puts(p);
    return (0);
}
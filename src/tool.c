#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main(int argc, char *argv[])
{
        char **newargv;
        char *newenviron[] = { "PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",NULL };
        uid_t  uid;
        gid_t  gid;

        if (argc < 2) {
                fprintf(stderr, "Usage: %s <file-to-exec>\n", argv[0]);
                exit(EXIT_FAILURE);
        }

        newargv = argv;
        newargv += 1;

        uid = geteuid();
        gid = getegid();

        setreuid(uid,uid);
        setregid(gid,gid);
        execve(argv[1], newargv, newenviron);
        perror("execve"); /* execve() only returns on error */
        exit(EXIT_FAILURE);
}

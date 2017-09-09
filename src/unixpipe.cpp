#include "unixpipe.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

UnixPipe::UnixPipe(QObject *parent) : QObject(parent), _err("none")
{
    _trace += "__constructor() ";
}

void UnixPipe::setCommand(const QString &cmd) {
    _cmd = cmd;
    _trace += "setCommand(" + cmd + ") ";
}

const QString UnixPipe::command() {
    _trace += "command() ";
    return _cmd;
}

bool UnixPipe::start() {
    int pdes[2];            // file descriptors from pipe(2)
    const size_t BuffSize = 2047;
    char buff[BuffSize+1];
    ssize_t bread, total;   // bytes read
    pid_t pid;

    _trace += "start() ";

    if (pipe(pdes) != 0) {
        _err += "pipe";
        return false;  // FIXME: error reporting
    }

    pid = fork();
    // The child process runs the external programm.
    if (pid == 0) {
        _trace += "child ";
        if (dup2(pdes[1], 1) == -1) {
            _err += "dup2";
            return false;
        }
        if (close(pdes[0]) == -1) {
            _err += "close";
            return false;
        }
        if (system(_cmd.toUtf8()) != 0) {
            _err += "system";
            return false;
            //perror("system");
        }
    }
    // The parent process catches the output.
    else if (pid == -1) {
        _err += "fork";
    }
    else {
        printf("-%i\n", pid);
        if (dup2(pdes[0], 0) == -1) {
            _err += "dup2";
            return false;
        }
        if (close(pdes[1]) == -1) {
            _err += "close";
            return false;
        }

        _trace += "parent=";

        bread = read(pdes[0], buff, BuffSize);
        total = bread;
        while (bread > 0) {
            buff[bread] = '\0';
            _pipedata += buff;
            bread = read(pdes[0], buff, BuffSize);
            total += bread;
        }
        _trace += QString::number(total);
    }

    return true;
}

const QString UnixPipe::data()  {
    _trace += "data() ";
    sleep(1);

    return _pipedata;
}

const QString UnixPipe::error()  {
    _trace += "error() ";
    return _err;
}

const QString UnixPipe::trace()  {
    _trace += "trace() ";
    return _trace;
}

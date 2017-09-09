#include "pipe.h"

Pipe::Pipe(QObject *parent) : QObject(parent), _proc(this)
{
    _proc.setProcessChannelMode(QProcess::MergedChannels);
}

void Pipe::setCommand(const QString &cmd) {
    _cmd = cmd;
    _proc.setProgram(_cmd);
}

const QString Pipe::command() const {
    return _cmd;
}

bool Pipe::start() {
    _proc.start(QIODevice::ReadOnly);
}

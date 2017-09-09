#ifndef CPIPE_H
#define CPIPE_H

#include <QObject>
#include <stdint.h>

class UnixPipe : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString command READ command WRITE setCommand)

public:
    explicit UnixPipe(QObject *parent = 0);

    void setCommand(const QString &cmd);
    const QString command() ;

    Q_INVOKABLE bool start();
    Q_INVOKABLE const QString data() ;
    Q_INVOKABLE const QString error() ;
    Q_INVOKABLE const QString trace() ;

signals:

public slots:

protected:
    QString _cmd, _pipedata, _err, _trace;
    static const size_t _BuffSize = 2047;
    char _buff[_BuffSize+1];
};

#endif // CPIPE_H

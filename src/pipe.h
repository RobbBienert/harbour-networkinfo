#ifndef PIPE_H
#define PIPE_H

#include <QObject>
#include <QProcess>

class Pipe : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString command READ command WRITE setCommand)

public:
    explicit Pipe(QObject *parent = 0);

    void setCommand(const QString &cmd);
    const QString command() const;

    Q_INVOKABLE bool start();

signals:

public slots:

protected:
    QProcess _proc;
    QString _cmd;
};

#endif // PIPE_H

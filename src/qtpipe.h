/*
 * Qt-based pipe connection for asynchronous reading
 *
 * Copyright (C) 2017 Robert Bienert <robertbienert@gmx.net>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef QTPIPE_H
#define QTPIPE_H

#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QVariantMap>

class QtPipe : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString command READ command WRITE setCommand)
	Q_PROPERTY(QString commandLine READ commandLine)
	Q_PROPERTY(QString data READ data NOTIFY dataChanged)
	Q_PROPERTY(bool mergeOutput READ mergeOutput WRITE setMergeOutput)

public:
	explicit QtPipe(QObject *parent = 0);

	void setCommand(const QString &cmd);
	const QString command() const;

	const QString commandLine() const;

	void setMergeOutput(const bool merge);
	bool mergeOutput() const;

	const QString data() const;
	Q_INVOKABLE QVariantMap getDataAsTable();

	Q_INVOKABLE void addCmdOptions(const QString &co);
	Q_INVOKABLE void addCmdFileArg(const QString &fa, const bool quote = true);
	Q_INVOKABLE bool start();
	Q_INVOKABLE void close();

signals:
	void newError(const QString &msg);
	void dataChanged(const QString& currentData);
	void stderrRead(const QString &err);
	void done(const QString &msg);

public slots:
	void errorOccurred(QProcess::ProcessError errorCode);
	void readyRead();
	void readyReadStandardError();
	void finished(int exitCode, QProcess::ExitStatus exitStatus);

protected:
	bool _merge;
	QProcess _pipe;
	QString _cmd, _pipedata;
	QStringList _args;
};

#endif // QTPIPE_H

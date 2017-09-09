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

#include "qtpipe.h"
#include <QRegularExpression>
#include <QVariantList>

QtPipe::QtPipe(QObject *parent) : QObject(parent), _pipe(this)
{
	setMergeOutput(false);

	QObject::connect(&_pipe, &QProcess::errorOccurred, this, &QtPipe::errorOccurred);
	QObject::connect(&_pipe, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished), this, &QtPipe::finished);
	QObject::connect(&_pipe, &QProcess::readyRead, this, &QtPipe::readyRead);
}

void QtPipe::setCommand(const QString &cmd) {
	_cmd = cmd;
}

const QString QtPipe::command() const {
	return _cmd;
}

const QString QtPipe::commandLine() const {
	return _cmd + ' ' + _args.join(' ');
}

void QtPipe::setMergeOutput(const bool merge) {
	_merge = merge;

	if (_merge) {
		_pipe.setProcessChannelMode(QProcess::MergedChannels);
		QObject::disconnect(&_pipe, &QProcess::readyReadStandardError, this, &QtPipe::readyReadStandardError);
	}
	else {
		_pipe.setProcessChannelMode(QProcess::SeparateChannels);
		QObject::connect(&_pipe, &QProcess::readyReadStandardError, this, &QtPipe::readyReadStandardError);
	}
}

bool QtPipe::mergeOutput() const {
	return _merge;
}


void QtPipe::addCmdOptions(const QString &co) {
	_args << co;
}

void QtPipe::addCmdFileArg(const QString &fa, const bool quote) {
	if (quote) {
		QString f('"');
		f += fa + '"';
		_args << f;
	}
	else
		_args << fa;
}

bool QtPipe::start() {
	_pipe.start(_cmd, _args, QIODevice::ReadOnly);
	return true;
}

void QtPipe::close() {
	_pipe.close();
	_args.clear();
	emit done("closed");
}

const QString QtPipe::data() const {
	return _pipedata;
}

QVariantMap QtPipe::getDataAsTable() {
	QStringList lines = _pipedata.split('\n');
	QStringList line;
	QRegularExpression reTab("\\s{2,}");
	QVariantList ld;
	QVariantMap res;
	QString header;
	int columns = 0, rows = 0;

	for (QStringList::iterator it = lines.begin(); it != lines.end(); ++it) {
		line = it->split(reTab);

		if (line.size() == 1) {
			header += *it;
		}
		else if (line.size() > 1) {
			if (columns == 0)
				columns = line.size();

			for (QStringList::iterator i = line.begin(); i != line.end(); ++i) {
				ld.append(*i);
			}

			++rows;
		}
	}

	res.insert("header", header);
	res.insert("data", ld);
	res.insert("columns", columns);
	res.insert("rows", rows);

	return res;
}

void QtPipe::readyRead() {
	QString buff(_pipe.readAll().data());

	emit dataChanged(buff);
	_pipedata += buff;
}

void QtPipe::readyReadStandardError() {
	emit stderrRead(QString(_pipe.readAllStandardError().data()));
}

void QtPipe::finished(int exitCode, QProcess::ExitStatus exitStatus) {
	QString code = QString::number(exitCode);

	switch (exitStatus) {
	case QProcess::NormalExit:
		emit done("exit with code " + code);
		break;
	case QProcess::Crashed:
		emit done("crashed with code " + code);
		break;
	default:
		emit done("unknown finish with code " + code);
	}
}

void QtPipe::errorOccurred(QProcess::ProcessError errorCode) {
	QString err;

	switch (errorCode) {
	case QProcess::FailedToStart:
		err = "failed to start " + _cmd;
		break;
	case QProcess::Crashed:
		err = "crashed";
		break;
	case QProcess::Timedout:
		err = "time out";
		break;
	case QProcess::ReadError:
		err = "error reading from pipe";
		break;
	default:
		err = "unknown error";
	}

	emit newError(err);
}

/*
 * interface to the ifconfig program using a pipe
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

#include "ifconfig.h"
#include <QVariantMap>

IfConfig::IfConfig(QObject *parent) : QtPipe(parent) {
	setCommand("/sbin/ifconfig");
}

bool IfConfig::parseIfConfig() {
	unsigned st = 0;	// state machine
	static const QChar N = '\n';
	QString tmps;
	NetworkInterface ni;
	unsigned ipv = 0;	// IP version

	for (QString::iterator it = _pipedata.begin(); it != _pipedata.end(); ++it)
	{
		if (st == 0) {
			if (it->isLetterOrNumber()) {
				ni.id = *it;
				st = 1;
			}
		}
		else if (st == 1) {
			if (it->isLetterOrNumber()) {
				ni.id += *it;
			}
			else if (it->isSpace()) {
				st = 2;
			}
			else {
				st = 0;
			}
		}
		else if (st == 2) {
			if (*it == ':') st = 3;
		}
		else if (st == 3) {
			if (*it == N) {
				_nifs.append(ni.asQtType());
				st = 10;
			}
			else if (it->isSpace()) {
				st = 4;
			}
			else {
				ni.type += *it;
			}
		}
		else if (st == 4) {
			if (it->isSpace()) {
				st = 5;
			}
			else if (it->isLetterOrNumber()) {
				ni.type += ' ' + *it;
				st = 3;
			}
		}
		else if (st == 5) {
			if (*it == N) {
				ni.hwaddr = ni.hwaddr.trimmed().right(17);
				st = 10;
			}
			else {
				ni.hwaddr += *it;
			}
		}
		else if (st == 10) {
			// a new interface
			if (it->isLetterOrNumber()) {
				_nifs.append(ni.asQtType());

				ni.id = *it;
				st = 1;
			}
			// empty line
			else if (*it == N) {}
			// data set continues
			else if (it->isSpace()) {
				st = 11;
			}
			else {
				//_err = "unknown char: " + it->toLatin1();
				st = 0;
			}
		}
		// 2nd line with inet addr
		else if (st == 11) {
			if (*it == N) st = 10;
			else if (*it == 'i') st = 12;
		}
		else if (st == 12) {
			st = *it == 'n' ? 13 : 11;
		}
		else if (st == 13) {
			st = *it == 'e' ? 14 : 11;
		}
		else if (st == 14) {
			st = *it == 't' ? 15 : 11;
		}
		else if (st == 15) {
			if (it->isSpace()) {
				st = 20;
				ipv = 4;
			}
			else if (*it == '6') {
				st = 16;
			}
			else st = 11;
		}
		else if (st == 16) {
			if (it->isSpace()) {
				st = 20;
				ipv = 6;
			}
			else st = 11;
		}
		else if (st == 20) {
			if (*it == ':') st = 21;
			else if (*it == N) st = 11;
		}
		else if (st == 21) {
			if (it->isLetterOrNumber() || *it == ':') {
				tmps = *it;
				st = 22;
			}
			else if (*it == N) st = 11;
		}
		else if (st == 22) {
			if (it->isLetterOrNumber() || *it == '.' || *it == ':'
					|| (*it == '/' && ipv == 6))
			{
				tmps += *it;
			}
			else if (it->isSpace()) {
				if (ipv == 4) {
					ni.ip4 = tmps;
					st = 30;
					tmps.clear();
					continue;
				}
				else if (ipv == 6)	ni.ip6 = tmps;
				tmps.clear();
				st = 23;
			}
		}
		else if (st == 23) {
			if (*it == N) st = 11;
		}
		else if (st == 30) {
			if (*it == ':')	st = 31;
			if (*it == N)	st = 11;
		}
		else if (st == 31) {
			if (it->isDigit() || *it == '.') {
				tmps += *it;
			}
			else if (*it == N) {
				ni.netmask = tmps;
				tmps.clear();
				st = 11;
			}
			else if (it->isSpace()) {
				tmps.clear();
				st = 30;
			}
		}
	}
	if (st != 0) {
		_nifs.append(ni.asQtType(false));
	}

	return true;
}

const QVariantList IfConfig::interfaces() const {
	return _nifs;
}

QVariantMap IfConfig::NetworkInterface::asQtType(const bool clear) {
	QVariantMap r;

	r.insert("nic", id);
	r.insert("desc", type);
	r.insert("hwaddr", hwaddr);
	r.insert("ipv4", ip4);
	r.insert("ipv6", ip6);
	r.insert("netmask", netmask);

	if (clear) {
		id.clear();
		type.clear();
		hwaddr.clear();
		ip4.clear();
		ip6.clear();
		netmask.clear();
	}

	return r;
}

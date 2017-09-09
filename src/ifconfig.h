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

#ifndef IFCONFIG_H
#define IFCONFIG_H

#include "qtpipe.h"
#include <QVariantList>
#include <QVariantMap>

class IfConfig : public QtPipe
{
	Q_OBJECT
	Q_PROPERTY(QVariantList interfaces READ interfaces)

public:
	explicit IfConfig(QObject *parent = 0);

	Q_INVOKABLE bool parseIfConfig();

	const QVariantList interfaces() const;

	struct NetworkInterface {
		QString id, type, hwaddr, ip4, ip6, netmask;

		QVariantMap asQtType(const bool clear = true);
	};

private:
	QVariantList _nifs;
};

#endif // IFCONFIG_H

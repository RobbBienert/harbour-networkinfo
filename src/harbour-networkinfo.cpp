/*
 * Network Info app for Sailfish OS
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

#include <QtQuick>	// need it for qmlRegisterType - not only in debug mode
#include <sailfishapp.h>
#include "ifconfig.h"
#include "hostinfo.h"
#include "qtpipe.h"

const char PACK_NAME[] = "harbour.networkinfo";	// package name
const int MAYOR = 1;							// mayor version
const int MINOR = 0;							// minor version

int main(int argc, char *argv[])
{
	qmlRegisterType<IfConfig>(PACK_NAME, MAYOR, MINOR, "IfConfig");
	qmlRegisterType<HostInfo>(PACK_NAME, MAYOR, MINOR, "HostInfo");
	qmlRegisterType<QtPipe>(PACK_NAME, MAYOR, MINOR, "QtPipe");

    return SailfishApp::main(argc, argv);
}

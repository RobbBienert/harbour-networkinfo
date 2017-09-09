.pragma library

/*
 * shared ifconfig data
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

var _ifConfigString;

function ifconfigData() {
	return _ifConfigString
}

function setIfconfiData(data) {
	_ifConfigString = data
}

var _interfaces = []

function interfaces() {
	return _interfaces
}

function addInterface(name, addr) {
	_interfaces.push({name: name, addr: addr})
}

/*
 * key value label in a grid like order
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

import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    property string key: ''
    property string value: ''
    property int bold: 1
    property int italic: 2
    property int keyFormat: 0

    visible: value.length > 0

    Label {
        text: key
        font.bold: keyFormat == bold
        font.italic: keyFormat == italic
    }
    Label { text: ': '  }
    Label { text: value }
}

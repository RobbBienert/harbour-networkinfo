/*
 * cover page for harbour-networkinfo
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
import '../types'
import '../js/SharedData.js' as SharedData

CoverBackground {
    Column {
        anchors.centerIn: parent
        x: Theme.paddingSmall
        width: parent.width - 2*x

        Label {
            id: label
            text: qsTr("Interfaces")
            font.bold: true
            height: 2*Theme.fontSizeSmall
        }

        Repeater {
            model: ListModel {
                Component.onCompleted: {
                    var interfaces = SharedData.interfaces()

                    for (var i = 0; i < interfaces.length; ++i) {
                        append(interfaces[i])
                    }
                }
            }
            Column {
                Label { text: model.name }
                Label { text: model.addr }
            }
        }

        /*
        CoverActionList {
            id: coverAction

            CoverAction {
                iconSource: "image://theme/icon-cover-next"
            }

            CoverAction {
                iconSource: "image://theme/icon-cover-pause"
            }
        }
        */
    }
}


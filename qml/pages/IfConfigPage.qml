/*
 * ifconfig data
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
import harbour.networkinfo 1.0
import '../js/SharedData.js' as SharedData

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Copy to Clipboard")
                onClicked: Clipboard.text = ifout.text
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    pipe.start()
                }
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "ifconfig"
            }

            TextArea {
                id: ifout
                width: parent.width
                readOnly: true
                text: SharedData.ifconfigData()
            }
        }
    }
    IfConfig {
        id: pipe

        onDone: {
            pipe.parseIfConfig()
            SharedData.setIfconfiData(pipe.data)
        }
    }
}

/*
 * page for capturing pipe output at once
 *
 * Copyright (C) 2017 - 2018 Robert Bienert <robertbienert@gmx.net>
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

Page {
    id: page
    allowedOrientations: Orientation.All
    property string toolName: ''
    property string toolCmd: ''
    property var toolCmds: []
	property var altTools: []

	// This function is used to switch the command output appropriate
	// to the screen orientation.
	function showHideResult() {
		page.isLandscape = (page.orientation | Orientation.LandscapeMask) === Orientation.LandscapeMask
		page.isPortrait = (page.orientation | Orientation.PortraitMask) === Orientation.PortraitMask

		resultTable.visible = header.visible = page.isLandscape
		result.visible = page.isPortrait
	}

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Copy to Clipboard")
                onClicked: Clipboard.text = ifout.text
            }
        }

        Column {
            id: column

            x: Theme.paddingMedium
            width: page.width - 2*x
            spacing: Theme.paddingLarge

            PageHeader {
                title: toolName
            }

            Label {
                id: header
                width: parent.width
            }

            Grid {
                id: resultTable
                width: parent.width
                spacing: Theme.paddingSmall

                Repeater {
                    id: gridList

                    Label {
                        width: parent.parent.width / parent.parent.columns
                        text: modelData
                    }
                }
            }

            TextArea {
                id: result
                width: parent.width
                readOnly: true
            }
        }
    }

    QtPipe {
        id: pipe
        command: toolCmd
        onDone: {
            result.text = pipe.data
            var data = pipe.getDataAsTable()

            header.text = data.header
            resultTable.columns = data.columns
            gridList.model = data.data
        }
    }

    Component.onCompleted: {
        pipe.start()
        showHideResult()
    }
    onOrientationChanged: showHideResult()
}

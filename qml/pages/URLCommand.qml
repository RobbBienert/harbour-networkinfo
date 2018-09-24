/*
 * URL command tool
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
    id: ping
    allowedOrientations: Orientation.All
    property string toolName: ''
    property string toolCmd: ''
    property var toolCmds: []
    property string cmdOpt: ''

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
            width: ping.width - 2*x
            spacing: Theme.paddingLarge

            PageHeader {
                title: toolName
            }

            TextField {
                id: ip
                label: "URL"
                placeholderText: label
                width: parent.width
                EnterKey.enabled: text.length > 0 && acceptableInput
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: startPipe()
                inputMethodHints: Qt.ImhUrlCharactersOnly
                //validator: RegExpValidator { regExp: /^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|([0-9a-fA-F\:]+)|([0-9a-zA-Z][0-9a-zA-Z\-\.]+[0-9a-zA-Z])$/ }
            }
            //*
            Row {
                width: parent.width
                spacing: Theme.paddingMedium

                TextSwitch {
                    id: compress
                    text: qsTr("Compress")
                    description: qsTr("… HTTP transfer")
                    width: parent.width // 2
                }
                BusyIndicator {
                    id: busy
                }

                /*
                TextField {
                    id: lang
                    label: qsTr("Language")
                    placeholderText: qsTr("Language")
                    width: parent.width / 2
                }
                */
            }
            //*/

            TextArea {
                id: result
                width: parent.width
                readOnly: true
            }
        }
        VerticalScrollDecorator {}
    }

    QtPipe {
        id: pipe
        command: toolCmd
        onDataChanged: {
            result.text += currentData
        }
        onNewError: console.error(msg)
        onDone: {
            busy.running = false
        }
    }

    function startPipe() {
        var cmd;

        if (toolCmds.length === 0)
            cmd = toolCmd
        else if (toolCmds.length === 1){
            cmd = toolCmds[0]
        }
        else {
            cmd = ip.text.indexOf(':') === -1 ? toolCmds[0] : toolCmds[1]
        }

        result.text = ''
        pipe.command = cmd
        if (cmdOpt !== '')
			pipe.addCmdOption(cmdOpt)
        if (compress.checked)
			pipe.addCmdOption('--compressed')
		pipe.addCmdOption(ip.text)
        busy.running = pipe.start()
    }
}

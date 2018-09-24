/*
 * page for continously capturing pipe output
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
	property var altTools: []
    property string cmdOpt: ''
    property int iterations: 0
    property string iterName: ''

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
                label: qsTr("IP address or Hostname")
                placeholderText: qsTr("IP address or Hostname")
                width: parent.width
                EnterKey.enabled: text.length > 0 && acceptableInput
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: startPipe()
				validator: RegExpValidator { regExp: /^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|([0-9a-fA-F\:]+)|([0-9a-zA-Z][0-9a-zA-Z\-\.]+[0-9a-zA-Z]+)\s?$/ }
            }

            Grid {
                columns: 3
                width: parent.width
                spacing: Theme.paddingMedium

                TextField {
                    id: iter
                    label: iterName
                    width: (parent.width - parent.spacing) / 2
                    EnterKey.enabled: text.length > 0
                    EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                    EnterKey.onClicked: startPipe()
                    text: iterations
                    inputMethodHints: Qt.ImhDigitsOnly
                }

                BusyIndicator {
                    id: busy
                }

                IconButton {
                    icon.source: "image://theme/icon-m-reset"
                    onClicked: {
                        pipe.close()
                        busy.running = false
                    }
                }
            }

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
        mergeOutput: true
        onDataChanged: {
            result.text += currentData
        }
        onDone: {
            busy.running = false
        }
        onStderrRead: console.info(err)
        onNewError: console.error(msg)
    }

    function startPipe() {
		var cmd, altCmd;
		var ipv4 = ip.text.indexOf(':') === -1;

		ip.text = ip.text.trim()

		if (toolCmds.length === 0) {
            cmd = toolCmd
		}
		else if (toolCmds.length === 1) {
            cmd = toolCmds[0]
        }
        else {
			cmd = ipv4 ? toolCmds[0] : toolCmds[1]
        }

		if (altTools.length === 1) {
			pipe.altCommand = altTools[0]
		}
		else if (altTools.length === 2) {
			pipe.altCommand = ipv4 ? altTools[0] : altTools[1]
		}

        result.text = ''
        pipe.command = cmd
		if (cmdOpt !== '') {
			pipe.addCmdOption(cmdOpt)
			pipe.addCmdOption(iter.text)
		}
        pipe.addCmdFileArg(ip.text, false)
        busy.running = pipe.start()
    }
}

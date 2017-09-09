/*
 * Network Tools
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
import "../types"

Page {
    id: tools
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            x: Theme.paddingMedium
            width: tools.width - 2*x
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Network Tools")
            }

            ToolRouter {
                name: "Ping"
                tools: ["/bin/ping", "/bin/ping6"]
                toolOpt: '-c'
                iterations: 5
                iterName: qsTr("number of pings")
                isStatic: false
            }
            ToolRouter {
                name: "Trace Route"
                tools: ["/usr/sbin/tracepath", "/usr/sbin/tracepath6"]
                //toolOpt: '-m'
                iterations: 30
                iterName: qsTr("hops")
                isStatic: false
            }
            Button {
                x: (parent.width - width) / 2
                text: 'whois'
                onClicked: pageStack.push(Qt.resolvedUrl('tools/Whois.qml'))
            }

            ToolRouter {
                name: "Routing"
                tool: "/sbin/route"
            }
            ToolRouter {
                name: "ARP"
                tool: "/sbin/arp"
            }
            Button {
                text: "HTTP HEAD"
                x: (parent.width - width) / 2
                onClicked: pageStack.push(Qt.resolvedUrl('URLCommand.qml'), { toolName: 'HTTP HEAD', toolCmd: "/usr/bin/curl", cmdOpt: '-LI' })
            }
        }
    }
}

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

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.networkinfo 1.0
import '../types'
import '../js/SharedData.js' as SharedData

Page {
    id: page
	allowedOrientations: Orientation.All

    HostInfo {
        id: host
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About …")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Show ifconfig Details")
                onClicked: pageStack.push(Qt.resolvedUrl("IfConfigPage.qml"))
            }
            MenuItem {
                text: qsTr("Network Tools")
                onClicked: pageStack.push(Qt.resolvedUrl("ToolsPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            x: Theme.paddingMedium
            width: page.width - 2*x
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Network Settings")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Interfaces")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Repeater {
                id: interfaceList

                Column {
                    KeyValueLabel {
                        key: modelData.nic
                        value: modelData.desc
                        keyFormat: bold
                    }
                    KeyValueLabel {
                        key: qsTr("Mac Address")
                        value: modelData.hwaddr
                    }
                    KeyValueLabel {
                        key: "IPv4"
                        value: modelData.ipv4
                    }
                    KeyValueLabel {
                        key: qsTr("Netmask")
                        value: modelData.netmask
                    }
                    KeyValueLabel {
                        key: "IPv6"
                        value: modelData.ipv6
                    }
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Host")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Column {
                KeyValueLabel {
                    key: qsTr("Host")
                    value: host.hostname
                }
                KeyValueLabel {
                    key: qsTr("Domain")
                    value: host.domainname
                }
            }
        }
        VerticalScrollDecorator {}
    }

    IfConfig {
        id: pipe
        onDone: {
            pipe.parseIfConfig()

            interfaceList.model = pipe.interfaces
            SharedData.setIfconfiData(pipe.data)
            for (var i = 0; i < pipe.interfaces.length; ++i) {
                SharedData.addInterface(pipe.interfaces[i].nic,
                                        pipe.interfaces[i].ipv4)
            }
        }
    }
    Component.onCompleted: pipe.start()
}

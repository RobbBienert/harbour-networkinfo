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
import "../types"

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("About Network Info")
            }

            SailText {
				text: "Version 1.1\nCopyright © 2017 Robert Bienert"
            }
            TextWithLink {
                text: '<a href="https://github.com/RobbBienert/harbour-networkinfo"><font color="' + Theme.highlightColor + '">Git Repository &amp; Wiki</font></a>'
            }

            SailTextHeader {
                text: qsTr("Description")
            }

            SailText {
                text: qsTr("This app provides some information of the local networks that your Jolla Phone is connected to. There are also some useful networking tools like <i>ping</i> included.")
                textFormat: Text.StyledText
            }

			SailTextHeader { text: qsTr("Credits") }
			SailText {
				text: qsTr("Swedish translation:") + " <a href=\"https://github.com/eson57\"><font color=\"" + Theme.highlightColor + "\">eson57</font></a>"
				textFormat: Text.StyledText
			}

            SailTextHeader {
                text: qsTr("License")
            }

            TextWithLink {
                text: qsTr("This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.<br>This program is distributed in the hope that it will be useful, but <strong>without any warranty</strong>; without even the implied warranty of <strong>merchantability</strong> or <strong>fitness for a particular purpose</strong>.") +  ' <a href="http://www.gnu.org/licenses/gpl-3.0"><font color="' + Theme.highlightColor + '">' + qsTr("See the GNU General Public License for more details.</font></a>")
            }
        }
        VerticalScrollDecorator {}
    }
}

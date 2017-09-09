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

Button {
    property string tool: ''
    property string name: ''
    property var tools: []
    property bool isStatic: true
    property string toolOpt: ''
    property int iterations: 0
    property string iterName: ''

    x: (parent.width - width) / 2
    text: name
    onClicked: {
        var qmlFile = "../pages/CommandOnce"
        var pageOpts = { toolName: name, toolCmd: tool }
        if (isStatic) {
            qmlFile += 'Output'
        }
        else {
            qmlFile += 'Update'
            pageOpts.toolCmds = tools
            pageOpts.cmdOpt = toolOpt
            pageOpts.iterations = iterations
            pageOpts.iterName = iterName
        }
        qmlFile += ".qml"

        pageStack.push(Qt.resolvedUrl(qmlFile), pageOpts)
    }
}

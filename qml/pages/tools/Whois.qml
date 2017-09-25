import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../types"
import harbour.networkinfo 1.0

Page {
    id: tools
    allowedOrientations: Orientation.All
    property string ipv4: ''
    property string ipv6: ''

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Copy IPv6 to Clipboard")
                onClicked: Clipboard.text = tools.ipv6
            }

            MenuItem {
                text: qsTr("Copy IPv4 to Clipboard")
                onClicked: Clipboard.text = tools.ipv4
			}
        }

        Column {
            id: column

            x: Theme.paddingMedium
            width: tools.width - 2*x
            spacing: Theme.paddingLarge

            PageHeader {
                title: 'whois'
            }

            TextField {
                id: hostname
                placeholderText: qsTr('Hostname')
                width: parent.width
                EnterKey.enabled: text.length > 0
                EnterKey.onClicked: {
                    ips.text = ''
                    tools.ipv4 = ''
                    tools.ipv6 = ''
                    var addrs = hi.gethostbyname(text.trim())

                    for (var i = 0; i < addrs.length; ++i) {
                        ips.text += addrs[i].family + ': ' + addrs[i].socktype + ' ' + addrs[i].addr + '\n'

						if (addrs[i].family === 'IPv4' && addrs[i].socktype === 'TCP') {
                            tools.ipv4 = addrs[i].addr
						}
						else if (addrs[i].family === 'IPv6' && addrs[i].socktype === 'TCP') {
                            tools.ipv6 = addrs[i].addr
						}
                    }
                }
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            }

            TextArea {
                id: ips
                width: parent.width
                readOnly: true
            }
        }
    }

    HostInfo {
        id: hi
    }
}

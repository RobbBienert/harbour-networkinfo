# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-networkinfo

CONFIG += sailfishapp

SOURCES += src/harbour-networkinfo.cpp \
    src/ifconfig.cpp \
    src/hostinfo.cpp \
    src/qtpipe.cpp

OTHER_FILES += qml/harbour-networkinfo.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-networkinfo.changes \
    rpm/harbour-networkinfo.spec \
    rpm/harbour-networkinfo.yaml \
    translations/*.ts \
    harbour-networkinfo.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-networkinfo-de.ts

HEADERS += \
    src/ifconfig.h \
    src/hostinfo.h \
    src/qtpipe.h

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/types/KeyValueLabel.qml \
    qml/pages/IfConfigPage.qml \
    qml/js/SharedData.js \
    qml/pages/ToolsPage.qml \
    qml/pages/CommandOutput.qml \
    qml/types/ToolRouter.qml \
    qml/pages/CommandUpdate.qml \
    qml/pages/About.qml \
    qml/pages/tools/Whois.qml \
    qml/js/NetUtils.js \
    qml/types/URLRouter.qml \
    qml/pages/URLCommand.qml \
    qml/types/SailText.qml \
    qml/types/SailTextHeader.qml \
    qml/types/TextWithLink.qml

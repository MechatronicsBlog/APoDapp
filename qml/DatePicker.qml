/////////////////////////////////////////////////////////////////////////
//  Name: DatePicker
//  Purpose: Date picker QML component
//
//  Author:  Javier Bonilla
//  Version: 1.0
//  Date:    06/02/2019
//
//  Copyright 2019 - Mechatronics Blog - https://www.mechatronicsblog.com
//
//  More info and tutorial: https://www.mechatronicsblog.com
/////////////////////////////////////////////////////////////////////////

import VPlayApps 1.0
import QtQuick 2.11
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.2

Row {
    id: row

    anchors.horizontalCenter: parent.horizontalCenter

    property date selectedDate: new Date()

    signal accepted(string dateStr)

    AppTextField{
        id: textDate
        anchors.verticalCenter: parent.verticalCenter
        width: dp(120)
        height: dp(30)
        borderWidth: dp(2)
        borderColor: Theme.tintColor
        radius: dp(20)
        placeholderText: "yyyy-mm-dd"
        horizontalAlignment: TextInput.AlignHCenter
        enabled: false
    }

    IconButton{
        anchors.verticalCenter: parent.verticalCenter
        icon: IconType.calendar
        onClicked: dateDialog.open()
    }

    Dialog{
        id: dateDialog
        visible: false
        modality: Qt.NonModal
        title: "Choose a date"

        onAccepted:{
            textDate.text = Qt.formatDateTime(calendar.selectedDate,"yyyy-MM-dd")
            dateDialog.close()
            row.accepted(textDate.text)
        }

        onDiscard: dateDialog.close()

        contentItem: Calendar{
            id: calendar
            locale: Qt.locale("en_EN")
            selectedDate: row.selectedDate
            onClicked: dateDialog.click(StandardButton.Ok)
        }
    }
}

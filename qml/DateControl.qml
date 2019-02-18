/////////////////////////////////////////////////////////////////////////
//  Name: DateControl
//  Purpose: Date picker QML component
//
//  Author:  Javier Bonilla
//  Version: 1.1
//  Date:    08/02/2019
//
//  Copyright 2019 - Mechatronics Blog - https://www.mechatronicsblog.com
//
//  More info and tutorial: https://www.mechatronicsblog.com
/////////////////////////////////////////////////////////////////////////

import QtQuick 2.11
import QtQuick.Controls 1.2
import Felgo 3.0

Item{
    id: item
    width: parent.width
    height: row.height
    property date selectedDate: new Date()
    property alias isDialogOpenend: dateDialog.isOpen

    signal accepted(string dateStr)
    signal cancelled()
    signal opened()

    Row {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        property date selectedDate: new Date()

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
            onClicked: {
                item.opened()
                dateDialog.open()
            }
        }

    }

    Dialog{
        id: dateDialog
        title: "Choose a date"
        autoSize: true
        outsideTouchable: false

        onAccepted:{
            textDate.text = Qt.formatDateTime(calendar.selectedDate,"yyyy-MM-dd")
            dateDialog.close()
            parent.accepted(textDate.text)
        }

        onCanceled: {
            dateDialog.close()
            parent.cancelled()
        }

        Calendar{
            id: calendar
            width: parent.width
            locale: Qt.locale("en_EN")
            selectedDate: parent.selectedDate
            onDoubleClicked: dateDialog.accepted()
        }
    }
}

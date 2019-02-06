/////////////////////////////////////////////////////////////////////////
//  Name: DescriptionBlock
//  Purpose: Description block QML component
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

Rectangle{
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width - 2*dp(10)
    height: columnDescription.height
    border.width: dp(2)
    border.color: Theme.tintColor
    radius: dp(20)
    visible: text
    color: "transparent"

    property string text

    Rectangle{
        anchors.fill: parent
        opacity: 0.2
        color: Theme.tintColor
        radius: parent.radius
    }

    Column{
        id: columnDescription
        width: parent.width
        topPadding: dp(15)
        bottomPadding: dp(20)
        spacing: dp(10)

        AppText{
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Description")
            color: Theme.tintColor
            font.bold: true
            font.pixelSize: sp(18)
        }

        AppText{
            id: description
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            leftPadding: dp(15)
            rightPadding: dp(15)
            wrapMode: AppText.WordWrap
            font.pixelSize: sp(14)
            horizontalAlignment: AppText.AlignJustify
            text: root.text
        }
    }
}

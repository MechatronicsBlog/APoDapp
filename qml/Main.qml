/////////////////////////////////////////////////////////////////////////
//  Name: APoDapp
//  Purpose: Astronomy Picture of the Day QML and Javascript app
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
import VPlay 2.0
import QtQuick 2.11
import QtQuick.Controls 2.4 as Quick2
import QtMultimedia 5.8

App {
    id: app

    onInitTheme: {
      Theme.colors.tintColor = "#1e73be"
      Theme.navigationBar.backgroundColor = Theme.colors.tintColor
      Theme.navigationBar.titleColor = "white"
    }

    NavigationStack {

        Page {
            id: page
            title: qsTr("NASA - Astronomy Picture of the Day")

            Image{
                anchors.fill: parent
                source: "../assets/MTB_background.jpg"
                fillMode: Image.PreserveAspectCrop
                opacity: 0.5
            }

            Flickable{
                anchors.fill: parent
                contentWidth: column.width
                contentHeight: column.height
                flickableDirection: Flickable.VerticalFlick

                Column{
                    id: column
                    width: page.width
                    spacing: dp(10)
                    topPadding: dp(10)
                    bottomPadding: dp(30)

                    Image{
                        source: "../assets/MTB_logo.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - dp(40)
                    }

                    AppText{
                        id: date
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Choose date")
                    }

                    DatePicker{
                        id: datePicker
                        onAccepted: request_nasa_image(dateStr)
                    }

                    AppText{
                        id: message
                        horizontalAlignment: AppText.AlignHCenter
                        font.bold: true
                        wrapMode: AppText.WordWrap
                        width: parent.width - 2*dp(10)
                    }

                    AppText{
                        id: author
                        horizontalAlignment: AppText.AlignHCenter
                        wrapMode: AppText.WordWrap
                        font.pixelSize: sp(12)
                        font.bold: true
                        width: parent.width - 2*dp(10)
                    }

                    Quick2.ProgressBar{
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: nasaImage.status === Image.Loading
                        value: nasaImage.progress
                        from: 0
                        to: 1
                    }


                    Image {
                        id: nasaImage
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: nasaImage.status === Image.Ready
                        fillMode: Image.PreserveAspectFit
                        width: parent.width - 2*dp(10)
                        MouseArea{
                            anchors.fill: parent
                            onClicked: nativeUtils.openUrl(nasaImage.source)
                        }
                    }

                    YouTubeWebPlayer{
                        id: nasaVideo
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 2*dp(10)
                        visible: false
                    }

                    DescriptionBlock{
                        id: descriptionBlock
                    }
                }
            }
        }
    }

    function request_nasa_image(dateStr)
    {
        const apiKey  = "NFzBwcb7GKLssQ7mzIEbyidXglcPhQlz5iaUiZfU"
        const Http_OK = 200

        var url    = "https://api.nasa.gov/planetary/apod"
        var params = "date=" + dateStr + "&api_key=" + apiKey

        clearInfo()
        get_request(url,params,
            function(http)
            {
                if (http.status === Http_OK)
                {
                    var res_json = JSON.parse(http.responseText)
                    if (res_json !== {})
                    {
                        message.color         = Theme.tintColor
                        message.text          = res_json.title
                        descriptionBlock.text = res_json.explanation

                        if (res_json.media_type === "image")
                            nasaImage.source = res_json.url
                        else if (res_json.media_type === "video")
                        {
                            nasaVideo.loadVideo(youtube_parser(res_json.url),true)
                            nasaVideo.visible = true
                        }

                        if (res_json.copyright !== undefined)
                        {
                            author.visible = true
                            author.text = "Copyright " + IconType.copyright + " " + res_json.copyright
                        }
                        else
                            author.visible = false

                        return
                    }
                }
                message.color = "red"
                message.text  = qsTr("No data found")
            }
        )
    }

    function get_request(url,params,callback)
    {
        var http = new XMLHttpRequest()

        http.onreadystatechange = function(myhttp)
        {
            return function() {
                if (myhttp.readyState === XMLHttpRequest.DONE)
                    callback(myhttp)
            }
        }(http)
        http.open("GET", url + "?" + params, true)
        http.send()
    } 

    function clearInfo()
    {
        message.text           = ""
        nasaImage.source       = ""
        nasaVideo.videoId      = ""
        nasaVideo.visible      = false
        author.text            = ""
        descriptionBlock.text  = ""
    }

    function youtube_parser(url)
    {
        var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
        var match  = url.match(regExp)
        return (match&&match[7].length === 11)? match[7] : ""
    }
}

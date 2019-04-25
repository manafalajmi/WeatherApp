﻿import QtQuick 2.7
import QtQuick.Controls 2.1
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3


Page {
    signal openMap();

    //Mock Weather Data
    property var lon: 0
    property var lat: 0;
    property date dateChecked: new Date()
    property string city: "Seattle"
    property string weatherDisc: "Windy"
    property int currentTemp: 280;
    property string weatherIcon : "10d"
    property int forecastLength : 5 ;




    // COMPONENTS
    PositionSource{
        id: userPosition
        active: false
        updateInterval: 10000
        onPositionChanged: {
            if(userPosition.position.latitudeValid && userPosition.position.latitudeValid){
                updateCurrentLocation();
                stop();
            }
        }
    }

    Rectangle {

        id: todaysTemp
        anchors.top: parent.top ;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: parent.height/2;
        color:"red";

        Label {
            id: temp
            text: lon
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color:"white"
            Component.onCompleted: {

            }

        }

        Button {
            height: 50
            width: parent.width /4
            text: "Open Map"
            font.pixelSize:20
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            onClicked:{
openMap();
            }
        }

        ComboBox {
            id: forecastLengthBox
            currentIndex: 0
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
//            model:
//            {
//                id: lengthList
//                ["5","6","7", "8", "9", "10"]
//            }
            model: ListModel {
                    id: forecastDays
                    ListElement { text: "5"; }
                    ListElement { text: "6";  }
                    ListElement { text: "7";}
                    ListElement { text: "8";}
                    ListElement { text: "9";}
                    ListElement { text: "10";}
                }

            width: 200
            onCurrentIndexChanged: {
//                console.log("Changing forecast length");
//                console.log(forec)
//                console.log(forecastDays.get(currentIndex).text)
                forecastLength = forecastDays.get(currentIndex).text;
                networkRequest.send();

            }
        }


        Label {
            id: todaysDate
            text:dateChecked.toDateString("DD:MM:YYYY")
            anchors.bottom: todayTempBreakdown.top;
            anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
        }


        Row {
            spacing:2;
            anchors.bottom: todaysDate.top;
            anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
            Label {
                id: cityLabel
                text:city

                font.pixelSize: 22;
                padding: 2;
            }
            Label {
                id:lattAndLon
                text: lat + "   " + lon;


                font.pixelSize: 22;

            }
        }


        Rectangle {
            id: todayTempBreakdown
            height:parent.height/2;
            width:parent.height/2;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.verticalCenter: parent.verticalCenter;
            color:"black"


            Image {
                id: weatherDiscIcon
                source: "http://openweathermap.org/img/w/"+weatherIcon+".png"
                anchors.bottom: currentTempLabel.top;
                anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
            }

            Label {
                id: currentTempLabel
                text: (currentTemp-270) + "C"
                anchors.verticalCenter:  parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                color:"white"
                font.pixelSize: parent.width /3;
                font.bold: true
                fontSizeMode: Text.HorizontalFit;
                maximumLineCount: 1;
                Component.onCompleted: {
                    //On completed make the API calls to get real weather data
                }

            }

            Label {
                id: weatherDiscLabel
                text: weatherDisc
                anchors.top: currentTempLabel.bottom;
                anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
                font.pixelSize: parent.width/4;
                color:"white"
            }


        }





        Item {
            NetworkRequest {
                id: networkRequest
                url:"http://api.openweathermap.org/data/2.5/forecast?lat="+lat+"&lon="+lon+"&appid=3618189b81665d2ecef99b81a314fe1a&cnt="+forecastLength+"&units=metric"
                responseType:"json"
                //                                Component.onCompleted: networkRequest.send( { f: "pjson" } );
                onReadyStateChanged:{

//                    console.log(JSON.stringify(networkRequest.response));
                    if ( readyState === NetworkRequest.DONE) {
//                        console.log("Requst is done status code unknown");
                        if (status === NetworkRequest.StatusCodeOK){
                            //TODO check for invalid response
//                            console.log(JSON.stringify(networkRequest.response));
//                            console.log("Finished the network request with coordinates");
//                            console.log(JSON.stringify(networkRequest.response["list"][0]));
                            if(city !==networkRequest.response["city"]["name"]){
                                city = networkRequest.response["city"]["name"];
                                weatherByCity.send({ f: "pjson" } );
                            }
                            //Forecast gets data starting at tommorows date
//                            currentTemp = networkRequest.response["list"][0]["main"]["temp"];
//                            weatherDisc = networkRequest.response["list"][0]["weather"][0]["description"];
//                            weatherIcon = networkRequest.response["list"][0]["weather"]["0"]["icon"];
                            forecastModel.clear();
                            for(var i=0; i<forecastLength; i++){
//                                console.log(i);
//                                console.log(JSON.stringify(networkRequest.response["list"][i]["weather"]))
                                var description = networkRequest.response["list"][i]["weather"][0]["description"]
                                var icon = networkRequest.response["list"][i]["weather"][0]["icon"]
                                var humidity= networkRequest.response["list"][i]["main"]["humidity"]
                                var futureDate = dateChecked;
                                futureDate.setDate(futureDate.getDate()+ i);
                               var high = networkRequest.response["list"][i]["main"]["temp_max"]
                                var low = networkRequest.response["list"][i]["main"]["temp_min"]
                                forecastModel.append({
                                                         date: futureDate.toDateString("DD:MM:YYYY"),
                                                         description: description,
                                                         icon: icon,
                                                         high: high,
                                                         low:  low,
                                                         humidity:humidity,
                                                     })


                            }


                        }
                    }
                }
            }

            NetworkRequest{
                id: weatherByCity
                url:"http://api.openweathermap.org/data/2.5/weather?q="+city +",us&appid=3618189b81665d2ecef99b81a314fe1a&units=metric"
                responseType:"json"
                Component.onCompleted: weatherByCity.send( { f: "pjson" } );
                onReadyStateChanged:{

                    if ( readyState === NetworkRequest.DONE) {
                        if (status === NetworkRequest.StatusCodeOK){

                            city = weatherByCity.response["name"];
                            currentTemp = weatherByCity.response["main"]["temp"];
//                            console.log("PRinting out the icon");
                            weatherDisc = weatherByCity.response["weather"][0]["description"];
                            weatherIcon = weatherByCity.response["weather"]["0"]["icon"];
                            if((lat ===0  && lon ===0) || (lat !== weatherByCity.response["coord"]["lat"] || lon !==weatherByCity.response["coord"]["lon"] )) {
                                lat = weatherByCity.response["coord"]["lat"];
                                lon = weatherByCity.response["coord"]["lon"];
                                    networkRequest.send({ f: "pjson" })
                            }
                            weatherByCity.abort();
                        }
                    }
                }

            }
            TextArea {
                anchors.left: parent.left
                anchors.top: parent.top
                text: networkRequest.readyState === NetworkRequest.DONE ? networkRequest.responseText : networkRequest.readyState
            }
        }

    }

    Rectangle {
        id: nDayForecast

        anchors.top: todaysTemp.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: parent.height/2;
        color:"blue";


        ListModel{
            id: forecastModel

            ListElement {
                   date: ""
                   description: "Apple"
                   icon: "10d"
                   high: 10
                   low:  20
                   humidity: 10

               }
            ListElement {
                   date: ""
                   description: "Banana"
                   icon: "10d"
                   high: 10
                   low:  20
                   humidity: 10

               }
        }
        ListView {
            anchors.fill: parent
            model: forecastModel
            orientation: Qt.Horizontal
            layoutDirection: Qt.LeftToRight
            delegate: Column {


                Text { text: "\n date: " + date + "\n"}
                Text { text: "\n description"  + description }
                Image{ source: "http://openweathermap.org/img/w/"+icon+".png"  }
                Text { text: "high" + high + "\n"}
                Text { text: "low" + low + "\n"}
                Text { text: "humidity" + humidity+"%" + "\n"}

            }
        }

    }


    function updateCurrentLocation(){

        lat = parseFloat(Number(userPosition.position.coordinate.latitude)).toFixed(3);
        lon = parseFloat(Number(userPosition.position.coordinate.longitude)).toFixed(3);

        networkRequest.send( { f: "pjson" } );
//        console.log("LAT: " + lat +" LONG: " + lon);
    }



    Component.onCompleted: {
        //           console.log("Page is completed");
        userPosition.start();
    }
}



import QtQuick 2.7
import QtQuick.Controls 2.1
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3


Page {
    //Mock Weather Data
    property var lon: 47
    property var lat: 122;
    property date dateChecked: new Date()
    property string city: "Seattle"
    property string weatherDisc: "Windy"
    property int currentTemp: 280;
    property string weatherIcon : "10d"
    property int forecastLength : 2;




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



        Label {
            id: todaysDate
            text:dateChecked
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
                text:
                    //weatherIcon
                    weatherDisc
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

                    console.log(JSON.stringify(networkRequest.response));
                    if ( readyState === NetworkRequest.DONE) {
                        console.log("Requst is done status code unknown");
                        if (status === NetworkRequest.StatusCodeOK){
                            //TODO check for invalid response
                            console.log(JSON.stringify(networkRequest.response));
                            console.log("Finished the network request with coordinates");
                            console.log(networkRequest.response["city"]);
                            city = networkRequest.response["city"]["name"];
                            currentTemp = networkRequest.response["list"][0]["main"]["temp"];
                            weatherDisc = networkRequest.response["list"][0]["weather"][0]["description"];
                            weatherIcon = networkRequest.response["list"][0]["weather"]["0"]["icon"];
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
                            console.log("PRinting out the icon");
                            weatherDisc = weatherByCity.response["weather"][0]["description"];
                            weatherIcon = weatherByCity.response["weather"]["0"]["icon"];
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


    }


    function updateCurrentLocation(){

        lat = parseFloat(Number(userPosition.position.coordinate.latitude)).toFixed(3);
        lon = parseFloat(Number(userPosition.position.coordinate.longitude)).toFixed(3);

        networkRequest.send( { f: "pjson" } );
        console.log("LAT: " + lat +" LONG: " + lon);
    }



    Component.onCompleted: {
        //           console.log("Page is completed");
        userPosition.start();
    }
}



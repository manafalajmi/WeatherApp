import QtQuick 2.7
import QtQuick.Controls 2.1
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3


   Item {
       //Mock Weather Data
      property int lon: 1
      property int lat: 99
      property date dateChecked: new Date()
      property string city: "San Diego"
      property string weatherDisc: "Sunny"
      property int currentTemp: 22;



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

           Label {
               id: cityLabel
               text:city +"   " + lon + "  " + lat
               anchors.bottom: todaysDate.top;
               anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
               font.pixelSize: 22;
           }

           Rectangle {
                id: todayTempBreakdown
                height:parent.height/2;
                width:parent.height/2;
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.verticalCenter: parent.verticalCenter;
                color:"black"


                Label {
                    id: weatherDiscIcon
                    text:"weatherDiscIcon"
                    anchors.bottom: currentTempLabel.top;
                    anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
                    font.pixelSize: 12;
                    color:"white"
                }

                Label {
                    id: currentTempLabel
                    text: currentTemp + "C"
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
                    text:weatherDisc
                    anchors.top: currentTempLabel.bottom;
                    anchors.horizontalCenter: todayTempBreakdown.horizontalCenter;
                    font.pixelSize: parent.width/4;
                    color:"white"
                }


           }


           Button {
           id: getWeather
           text: "getWeather"
           anchors.top: todaysTemp.bottom;
           anchors.horizontalCenter: todaysTemp.horizontalCenter;
           onClicked: {
               //On completed make the API calls to get real weather data
                 console.log("printin the coordinates in current position");
                 lat = userPosition.position.coordinate.latitude
               //Look into parsing this data
                 lon = userPosition.position.coordinate.longitude
                 console.log("LAT: " + lat +" LONG: " + lon);
             }
           }

           // COMPONENTS
           PositionSource{
               id: userPosition
               active: true
               name: userPosition
           }
       }
   }



/* Copyright 2018 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


// You can run your app in Qt Creator by pressing Alt+Shift+R.
// Alternatively, you can run apps through UI using Tools > External > AppStudio > Run.
// AppStudio users frequently use the Ctrl+A and Ctrl+I commands to
// automatically indent the entirety of the .qml file.


import QtQuick 2.7
import QtQuick.Controls 2.1
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3
//import Esri.ArcGISRuntime 100.5

App {
    id: app
    width: 400
    height: 640

    //Navbar
    Rectangle {
        id: navbar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: 50 * AppFramework.displayScaleFactor
        color: app.info.propertyValue("titleBackgroundColor", "black")

        Text {
            id: titleText

            anchors.centerIn: parent


            text: app.info.title
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 18
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }


    }


    StackView {
        id: stackView

        anchors.top: navbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        initialItem: theWeatherView

        Button {
            height: 50
            width: parent.width /4
            text: "Map"
            font.pixelSize:20
            anchors.top:parent.top
            onClicked:{
//                stackView.pop();
//                mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeCompassNavigation;
//                mapView.locationDisplay.start();
                stackView.push(theMapView);
//                labelTest.text = "clicked"
            }
        }



        Component {
            id: theMapView
            TheMapView {
    //            onNext: {
    //              stackView.push(mapView);
    //            }
                onBack:{
                    stackView.clear(); //should be pop but doesn't work might be issue of length
                }
                Component.onCompleted: {
//                    mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeCompassNavigation;
                    theMapView.locationDisplay.start();
                }
            }
        }

        Component {
            id: theWeatherView
            WeatherView {
                Component.onCompleted: {
                }
            }
        }


        Label {
            id: labelTest
            text: ""+stackView.currentItem
        }
    }





}


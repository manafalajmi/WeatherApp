import QtQuick 2.7
import QtQuick.Controls 2.1
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3

   Item {
//       signal next();
       signal back();
//       background-color:"black"
//       color:"black"

//       MapView{
//           id: mapView
//       Map {
//            id: map

//            anchors {
//                left: parent.left
//                right: parent.right
//                top: titleRect.bottom
//                bottom: parent.bottom
//                fill: parent
//            }

//            plugin: Plugin {
//                preferred: ["ArcGIS"]
//            }

//            center {
//                latitude: 34.056573
//                longitude: -117.195855
//            }

//            gesture {
//                flickDeceleration: 3000
//                enabled: true
//            }

//            activeMapType: supportedMapTypes[0]
//            zoomLevel: 15

//        }
       
//   }


       MapView {
           id: mapView

           anchors.fill: parent
           Map {
               BasemapImagery {}
           }

           // set the location display's position source
           locationDisplay {
               positionSource: PositionSource {
               }
//                compass: Compass {}
           }
       }

       Button {
           id:backButton
                     height: 50
                     width: parent.width /4
                     text: "Back"
                     font.pixelSize:20
                     anchors.top:parent.top
                     anchors.left: parent.left
                     onClicked:{
                         console.log("adding the map to the view")
                         back();  
                         
                     }
                 }



       Button {
           id:locate
                     height: 50
                     width: parent.width /4
                     text: "locate"
                     font.pixelSize:20
                     anchors.top:backButton.bottom
                     anchors.left: parent.left
                     onClicked:{
                         mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
                         mapView.locationDisplay.start();

                     }
                 }
       Label {
           id: labelId
           anchors.bottom: parent.bottom
           text: "in mapView"
           anchors.top: backButton.bottom
   }

   }



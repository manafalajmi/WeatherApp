import QtQuick 2.7
import QtQuick.Controls 2.1
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3

   Page {
       signal back();
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
   }



//
//  ClassObject.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/9/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import UIKit
import GoogleMaps
struct ClassObject{
    var ClassName : String
    var MarkerColor : UIColor
    var RoomNumber : String
    var Longitude: Double
    var Latitude: Double
    var Markers = [[Int] : GMSMarker]()
    var Row : Int
    
}

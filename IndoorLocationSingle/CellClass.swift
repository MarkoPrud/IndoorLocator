//
//  CellClass.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/6/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import Foundation
class CellClass{
    var university: String
    var campus: String
    var _class: String
    var building: String
    var room: String
    var name: String
    init(uni: String, campus: String, _class: String, building: String, room: String, name: String) {
        self.university = uni
        self.campus = campus
        self._class = _class
        self.building = building
        self.room = room
        self.name = name
    }
    
}

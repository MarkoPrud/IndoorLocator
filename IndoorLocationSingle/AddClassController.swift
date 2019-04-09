//
//  AddClassController.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/6/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import UIKit

class AddClassController: UIViewController{
    
    @IBOutlet weak var textFieldUniversity: UITextField!
    @IBOutlet weak var textFieldCampus: UITextField!
    @IBOutlet weak var textFieldClass: UITextField!
    @IBOutlet weak var textFieldBuilding: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldRoom: UITextField!
    var uni = ""
    var campus = ""
    var _class = ""
    var building = ""
    var name = ""
    var room = ""
    var classList: [CellClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func save(_ sender: Any) {
        performSegue(withIdentifier: "root", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.uni = textFieldUniversity.text!
        self.campus = textFieldCampus.text!
        self._class = textFieldClass.text!
        self.building = textFieldBuilding.text!
        self.name = textFieldName.text!
        self.room = textFieldRoom.text!
        
        classList.append(CellClass(uni: self.uni, campus: self.campus, _class: self._class, building: self.building, room: self.room, name: self.name))
        
        
        let vc = segue.destination as! ViewController
        vc.university = self.uni
        vc.campus = self.campus
        vc._class = self._class
        vc.building = self.building
        vc.room = self.room
        vc.name = self.name
        vc.classList = self.classList
    }
   
    
    
}

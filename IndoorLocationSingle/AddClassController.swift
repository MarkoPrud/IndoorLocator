//
//  AddClassController.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/6/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import UIKit

class AddClassController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
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

    //Picker
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData: [String] = [String]()
    var valueSelected = 0
    
    //Hashmap
    var someProtocol = [String : [Double]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Floor1 Bottom Left
        someProtocol["101"] = [33.93751376341245, -84.52033448964357]
        someProtocol["106"] = [33.93743921628291, -84.52025536447763]
        someProtocol["108"] = [33.937369954152565, -84.52023725956678]
        someProtocol["110"] = [33.937321554076256, -84.52024798840284]
        someProtocol["130"] = [33.93724199986803, -84.52025268226862]
        someProtocol["132"] = [33.937191930747815, -84.52024597674608]
        someProtocol["134"] = [33.93713184776472, -84.52025335282087]
        
        //Floor1 Bottom Right
        someProtocol["135"] = [33.93714019262601, -84.52011991292238]
        someProtocol["133"] = [33.93719693766116, -84.52010717242956]
        someProtocol["131"] = [33.93724978839519, -84.52012594789267]
        someProtocol["109"] = [33.937388312795036, -84.52010784298182]
        someProtocol["107"] = [33.93744116341027, -84.52011991292238]
        
        //TODO Floor 1
        someProtocol["151"] = [33.93744116341027, -84.52011991292238]
        someProtocol["152"] = [33.93744116341027, -84.52011991292238]
        someProtocol["156"] = [33.93744116341027, -84.52011991292238]
        someProtocol["158"] = [33.93744116341027, -84.52011991292238]
        someProtocol["165"] = [33.93744116341027, -84.52011991292238]
        someProtocol["166"] = [33.93744116341027, -84.52011991292238]
        someProtocol["157"] = [33.93744116341027, -84.52011991292238]
        someProtocol["159"] = [33.93744116341027, -84.52011991292238]
        someProtocol["163"] = [33.93744116341027, -84.52011991292238]
        someProtocol["170"] = [33.93744116341027, -84.52011991292238]
        
        //TODO Floor 2
        someProtocol["201"] = [33.93744116341027, -84.52011991292238]
        someProtocol["202"] = [33.93744116341027, -84.52011991292238]
        someProtocol["203"] = [33.93744116341027, -84.52011991292238]
        someProtocol["204"] = [33.93744116341027, -84.52011991292238]
        someProtocol["157"] = [33.93744116341027, -84.52011991292238]
        someProtocol["157"] = [33.93744116341027, -84.52011991292238]






        //Room List
        pickerData = ["101", "106","107","108","110","130","131","132","133","134","135"]

        //Mapping Coordinates to Room
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        //self.toolBar.setBackgroundImage(UIImage(),forToolbarPosition: .any,barMetrics: .default)
        //self.toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        
    }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.valueSelected = row
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
        self.room = pickerData[valueSelected]
        
        
        classList.append(CellClass(uni: self.uni, campus: self.campus, _class: self._class, building: self.building, room: self.room, name: self.name, coordinates: someProtocol[pickerData[valueSelected]] ?? [0,0]))
        
        
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

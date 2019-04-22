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
        
        //Floor1 Left
        someProtocol["101"] = [33.93751376341245, -84.52033448964357]
        someProtocol["106"] = [33.93743921628291, -84.52025536447763]
        someProtocol["108"] = [33.937369954152565, -84.52023725956678]
        someProtocol["110"] = [33.937321554076256, -84.52024798840284]
        someProtocol["130"] = [33.93724199986803, -84.52025268226862]
        someProtocol["132"] = [33.937191930747815, -84.52024597674608]
        someProtocol["134"] = [33.93713184776472, -84.52025335282087]
        someProtocol["151"] = [33.937765, -84.520340]
        someProtocol["157"] = [33.937835, -84.520218]
        someProtocol["159"] = [33.937865, -84.520206]
        someProtocol["161"] = [33.937921, -84.520203]
        someProtocol["163"] = [33.938106, -84.520195]
        someProtocol["170"] = [33.938122, -84.520278]
        
        
        //Floor1 Right
        someProtocol["135"] = [33.93714019262601, -84.52011991292238]
        someProtocol["133"] = [33.93719693766116, -84.52010717242956]
        someProtocol["131"] = [33.93724978839519, -84.52012594789267]
        someProtocol["109"] = [33.937388312795036, -84.52010784298182]
        someProtocol["107"] = [33.93744116341027, -84.52011991292238]
        someProtocol["152"] = [33.937750, -84.520055]
        someProtocol["156"] = [33.937822, -84.520124]
        someProtocol["158"] = [33.937932, -84.520146]
        someProtocol["160"] = [33.937990, -84.520116]
        someProtocol["164"] = [33.938021, -84.520127]
        someProtocol["165"] = [33.938137, -84.520124]
        
        // Second floor left
        
        someProtocol["218"] = [33.937144, -84.520253]
        someProtocol["216"] = [33.937232, -84.520228]
        someProtocol["214"] = [33.937320, -84.520233]
        someProtocol["212"] = [33.937387, -84.520233]
        someProtocol["210"] = [33.937447, -84.520241]
        someProtocol["203"] = [33.937531, -84.520349]
        someProtocol["220"] = [33.937691, -84.520294]
        someProtocol["260"] = [33.937824, -84.520235]
        someProtocol["262"] = [33.937903, -84.520232]
        someProtocol["264"] = [33.937989, -84.520231]
        
        // Second floor right
        
        someProtocol["217"] = [33.937166, -84.520113]
        someProtocol["215a"] = [33.937310, -84.520135]
        someProtocol["215b"] = [33.937217, -84.520148]
        someProtocol["213"] = [33.937359, -84.520140]
        someProtocol["211"] = [33.937439, -84.520124]
        someProtocol["202"] = [33.937510, -84.520067]
        someProtocol["201"] = [33.937672, -84.520072]
        someProtocol["251"] = [33.937763, -84.520034]
        someProtocol["263"] = [33.937974, -84.520104]
        someProtocol["265"] = [33.938125, -84.520120]
        // ClassRoom List
        pickerData = ["101","106","108","110","130","132","134","135","133","131","107","151","157","161","163","170","152","156","158","160","164","165","218","216","214","212","210","203","220","260","262","264","217","215a","215b","213","211","201","251","263","265"]

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

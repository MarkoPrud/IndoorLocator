//
//  ViewController.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/6/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var university = ""
    var campus = ""
    var _class = ""
    var building = ""
    var room = ""
    var name = ""
    var classList: [CellClass] = []
    var currentRow: Int = 0

    @IBAction func AddClass(_ sender: Any) {
        
        performSegue(withIdentifier: "AddClass", sender: self)
    }
    @IBAction func Search(_ sender: Any) {
        
        performSegue(withIdentifier: "Search", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddClass"{
         let vc = segue.destination as! AddClassController
         vc.classList = self.classList
        }else if segue.identifier == "Preview"{
            let vc = segue.destination as! PreviewController
            vc.obj = classList[currentRow]
            vc.classList = self.classList
        }
        else{
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        if university == ""{
            
        }
        else{
            print("Uni: \(university)")
            print("campus:  \(campus)")
            print("class: \(_class)")
            print("building: \(building)")
            print("room: \(room)")
            print("name: \(name)")
        }
       
 

    }
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
   
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.classList[indexPath.row]._class
        
        return cell
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        currentRow = indexPath.row
        performSegue(withIdentifier: "Preview", sender: self)

        //classList.remove(at: indexPath.row)
        //tableView.reloadData()
    }
    
    
}


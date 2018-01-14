//
//  ProfileViewController.swift
//  HackAZ
//
//  Created by Andrew Phillips on 1/13/18.
//  Copyright © 2018 Andrew Phillips. All rights reserved.
//

import UIKit
import Firebase

var i:Int?
var report:String!

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var allergies: UILabel!
    @IBOutlet weak var currentMeds: UILabel!
    @IBOutlet weak var previousPhysician: UILabel!
    
    var ref: DatabaseReference?
    
    var patientReports = Array<String>()
    @IBOutlet weak var tableViewName: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        i=0
        self.ref = Database.database().reference()
        ref?.child("Users").child(clicked!).observeSingleEvent(of: .value, with: { snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            self.name.text = snapshotValue!["name"] as? String
            self.address.text = snapshotValue!["address"] as? String
            self.phoneNumber.text = snapshotValue!["phonenumber"] as? String
            self.birthday.text = snapshotValue!["birthday"] as? String
            self.allergies.text = snapshotValue!["allergies"] as? String
            self.currentMeds.text = snapshotValue!["currentmeds"] as? String
            self.previousPhysician.text = snapshotValue!["previousphysician"] as? String
        })
        ref?.child("Users").child(clicked!).child("reports").observeSingleEvent(of: .value, with: { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                print("Added report")
                self.patientReports.append("Report\(i!)")
                self.tableViewName.reloadData()
                i=i!+1
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let visit = patientReports[indexPath.row]
        cell.textLabel?.text = visit
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        report = patientReports[indexPath.row].description
        print("Tapped device: \(clicked)")
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowGet", sender: nil)
    }
    
}

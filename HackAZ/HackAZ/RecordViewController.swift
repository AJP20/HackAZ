//
//  RecordViewController.swift
//  HackAZ
//
//  Created by Andrew Phillips on 1/14/18.
//  Copyright © 2018 Andrew Phillips. All rights reserved.
//

import UIKit
import Firebase

class RecordViewController: UIViewController {
    
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var medicationLabel: UILabel!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        
        reportLabel.text = report
        ref?.child("Users").child(clicked!).child("reports").child(report).observeSingleEvent(of: .value, with: { snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            self.diagnosisLabel.text = snapshotValue!["diagnosis"] as? String
            self.stateLabel.text = snapshotValue!["state"] as? String
            self.statusLabel.text = snapshotValue!["status"] as? String
            self.medicationLabel.text = snapshotValue!["medication"] as? String
        })
    }
    
}

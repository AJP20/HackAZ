//
//  PatientProfileViewController.swift
//  HackAZ
//
//  Created by Andrew Phillips on 1/13/18.
//  Copyright © 2018 Andrew Phillips. All rights reserved.
//

import UIKit
import Firebase

class PatientProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var bloodTypeTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    @IBOutlet weak var currentMedsTextField: UITextField!
    @IBOutlet weak var previousPhysicianTextField: UITextField!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.ref = Database.database().reference()
        guard let UID = UIDevice.current.identifierForVendor?.uuidString else{ return }
        ref?.child("Users").child(UID).observeSingleEvent(of: .value, with: { snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            self.nameTextField.text = snapshotValue!["name"] as? String
            self.addressTextField.text = snapshotValue!["address"] as? String
            self.phoneNumberTextField.text = snapshotValue!["phonenumber"] as? String
            self.birthdayTextField.text = snapshotValue!["birthday"] as? String
            self.allergiesTextField.text = snapshotValue!["allergies"] as? String
            self.currentMedsTextField.text = snapshotValue!["currentmeds"] as? String
            self.previousPhysicianTextField.text = snapshotValue!["previousphysician"] as? String
        })
    }
    
    @IBAction func updateButton(_ sender: Any) {
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        //Users Bluetooth UID for iPhone
        guard let UID = UIDevice.current.identifierForVendor?.uuidString else{ return }
        
        //Import values into Firebase
        let values = ["name": nameTextField.text, "address": addressTextField.text, "phonenumber": phoneNumberTextField.text, "birthday": birthdayTextField.text, "bloodType": bloodTypeTextField.text, "allergies": allergiesTextField.text, "currentmeds": currentMedsTextField.text, "previousphysician": previousPhysicianTextField.text]
        ref = Database.database().reference()
        ref?.child("Users").child(UID).setValue(values, withCompletionBlock:{(error: Error?, ref: DatabaseReference) in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            if error != nil{
                self.displayMessage(userMessage: "Error when signing up.")
                return
            }
            else{
                self.displayMessage(userMessage: "Successful sign up.")
            }
        })
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowSend", sender: nil)
    }
    
    func displayMessage(userMessage:String) -> Void{
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK", style: .default){(action:UIAlertAction!)in
                DispatchQueue.main.async {
                    if(userMessage=="Succesful sign up."){
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    //bulit in method, act whenever the user touches screen *FIX*?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

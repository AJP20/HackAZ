//
//  AddReportViewController.swift
//  HackAZ
//
//  Created by Andrew Phillips on 1/13/18.
//  Copyright © 2018 Andrew Phillips. All rights reserved.
//

import UIKit
import Firebase

class AddReportViewController: UIViewController {
    
    var ref: DatabaseReference?
    
    @IBOutlet weak var diagnosisTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var medicationsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        let values = ["diagnosis": diagnosisTextField.text, "state": stateTextField.text, "status": statusTextField.text, "medications": medicationsTextField.text]
        
        self.ref = Database.database().reference()
        ref?.child("Users").child(clicked!).child("reports").child("report\(i!)").setValue(values, withCompletionBlock:{(error: Error?, ref: DatabaseReference) in
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

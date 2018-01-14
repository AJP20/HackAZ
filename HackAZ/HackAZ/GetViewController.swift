//
//  GetViewController.swift
//  HackAZ
//
//  Created by Andrew Phillips on 1/13/18.
//  Copyright © 2018 Andrew Phillips. All rights reserved.
//

import UIKit
import CoreBluetooth

var clicked:String?

class GetViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource {

    var centralManager: CBCentralManager!
    var peripherals = Array<CBPeripheral>()
    var peripheral: CBPeripheral!
    
    @IBOutlet weak var tableViewName: UITableView!
    
    //Activity indicator
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        let clicked = peripherals[indexPath.row]
        print("Tapped device: \(clicked)")
        centralManager.connect(clicked, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            print("centralManagerDidUpdateState: OFF")
        case .poweredOn:
            print("centralManagerDidUpdateState: ON")
            let serviceUUID = CBUUID(string: "591D25F5-DB0B-4C3E-8A35-B0F61D338FAE")
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        case .unsupported:
            print("Bluetooth not available")
        default: break
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral discovered: \(String(describing: peripheral.name))")
        if (!peripherals.contains(peripheral) && peripheral.name != nil){
            peripherals.append(peripheral)
        }
        tableViewName.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        print("centralManagerdidConnect to: \(String(describing: peripheral.name))")
        peripheral.delegate = self
        let serviceUUID = CBUUID(string: "591D25F5-DB0B-4C3E-8A35-B0F61D338FAE")
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager,didFailToConnect peripheral: CBPeripheral,error: Error?){
        if error != nil{
            print("didFailToConnect: Error: \(String(describing: error))")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        if let error = error {
            print("peripheraldidDiscoverServices: Failed… error: \(error)")
            return
        }
        let characteristicUUID = CBUUID(string: "1F47BB7F-2ED5-4F4F-A252-4018CBF2ED7F")
        for service in peripheral.services!{
            print("peripheraldidDiscoverServices: \(service)")
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        if let error = error {
            print("peripheraldidDiscoverCharacteristics: Failed… error: \(error)")
            return
        }
        for characteristic in service.characteristics!{
            print("peripheraldidDiscoverCharacteristics: \(characteristic)")
            peripheral.readValue(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        let data = String(data: characteristic.value!, encoding: String.Encoding.utf8) as String!
        print("characteristic.value: \(String(describing: data))")
        clicked = data
        print(clicked)
        
        removeActivityIndicator(activityIndicator: myActivityIndicator)
        
        displayMessage(userMessage: "Successfully received data.")
    }
    
    @IBAction func updateButton(_ sender: Any) {
        peripherals.removeAll()
        centralManager.stopScan()
        tableViewName.reloadData()
        performSegue(withIdentifier: "ShowSend", sender: nil)
    }
    @IBAction func profileButton(_ sender: Any) {
        if let test = clicked {
            print("Contains a value! It is \(test)!")
            performSegue(withIdentifier: "showProfile", sender: nil)
        } else {
            displayMessage(userMessage: "Please pick a patient.")
        }
    }
    
    func displayMessage(userMessage:String) -> Void{
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK", style: .default){(action:UIAlertAction!)in
                DispatchQueue.main.async {}}
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
    
}

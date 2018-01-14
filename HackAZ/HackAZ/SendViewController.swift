//
//  SendViewController.swift
//  HackAZ
//
//  Created by Andrew Phillips on 1/13/18.
//  Copyright © 2018 Andrew Phillips. All rights reserved.
//

import UIKit
import CoreBluetooth

class SendViewController: UIViewController, CBPeripheralManagerDelegate {

    var peripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("peripheralManagerDidUpdateState: ON")
            
            let test = "Test data"
            
            let serviceUUID = CBUUID(string: "591D25F5-DB0B-4C3E-8A35-B0F61D338FAE")
            let characteristicUUID = CBUUID(string: "1F47BB7F-2ED5-4F4F-A252-4018CBF2ED7F")
            
            let service = CBMutableService(type: serviceUUID, primary: true)
            
            let properties: CBCharacteristicProperties = [.read]
            let permissions: CBAttributePermissions = [.readable]
            let characteristic = CBMutableCharacteristic(
                type: characteristicUUID,
                properties: properties,
                value: test.data(using: .utf8),
                permissions: permissions)
            service.characteristics = [characteristic]
            peripheralManager.add(service)
        } else if peripheral.state == .poweredOff {
            print("peripheralManagerDidUpdateState: OFF")
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager,didAdd service: CBService,error: Error?){
        if let error = error{
            print("peripheralManagerDidAddService Failed… error: \(error)")
            return
        }
        print("peripheralManagerDidAddService: \(service)")
        print("peripheralManagerAddName: \(UIDevice.current.name)")
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [service.uuid], CBAdvertisementDataLocalNameKey: UIDevice.current.name])
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager,error: Error?){
        if let error = error {
            print("peripheralManagerDidStartAdvertising: Failed… error: \(error)")
            return
        }
        print("peripheralManagerDidStartAdvertising: \(peripheral)")
    }
    
    @IBAction func backButton(_ sender: Any) {
        peripheralManager.stopAdvertising()
        performSegue(withIdentifier: "ShowGet", sender: nil)
    }
}

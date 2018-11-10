//
//  ViewController.swift
//  MarmiCop
//
//  Created by Alisson Selistre on 10/11/18.
//  Copyright © 2018 Alisson Selistre. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var turnOnButton: UIButton!
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    var marmita: Marmita! {
        didSet {
            refreshUI()
        }
    }
    
    // MARK: view setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarmita()
        setupUI()
        setupListeners()
    }
    
    // MARK: setup
    
    private func setupUI() {
        turnOnButton.layer.masksToBounds = true
        turnOnButton.layer.cornerRadius = 50
        refreshUI()
    }
    
    private func setupListeners() {
        let database = Firestore.firestore()
        
        database.collection("marmitas").document("the_marmita").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            self.marmita = Marmita(dict: document.data())
            print("Current data for marmita: \(self.marmita!)")
        }
    }
    
    private func setupMarmita() {
        self.marmita = Marmita(dict: [
            "armada": false,
            "gemido": "",
            "userId": ""
            ])
    }
    
    private func refreshUI() {
        turnOnButton.backgroundColor = marmita.armada ? UIColor.marGreen : UIColor.marRed
        turnOnButton.setTitle(marmita.armada ? "DESLIGAR" : "LIGAR", for: UIControl.State.normal)
    }
    
    // MARK: beacon manager

    func startLocalBeacon() {

        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = "00000000-0000-0000-0000-000000000000"
        let localBeaconMajor: CLBeaconMajorValue = 1
        let localBeaconMinor: CLBeaconMinorValue = 292
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "MarmiCop")
        
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    // MARK: actions
    
    @IBAction func didPressTurnOnButton(_ sender: UIButton) {
        self.marmita.armada = !self.marmita.armada
        
        let database = Firestore.firestore()
        database.collection("marmitas").document("the_marmita").setData(self.marmita.toAnyObject()) { (error) in
            if let error = error {
                print("Error writing marmita: \(error)")
            } else {
                print("Marmita successfully written!")
            }
        }
    }
}

extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as! [String : Any]!)
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}


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

class ViewController: UIViewController {

    @IBOutlet weak var turnOnButton: UIButton!
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    var marmitaIsTurnedOn: Bool = false {
        didSet {
            if marmitaIsTurnedOn {
                startLocalBeacon()
            } else {
                stopLocalBeacon()
            }
            
            refreshUI()
        }
    }
    
    // MARK: view setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: setup UI
    
    private func setupUI() {
        turnOnButton.layer.masksToBounds = true
        turnOnButton.layer.cornerRadius = 50
        refreshUI()
    }
    
    private func refreshUI() {
        turnOnButton.backgroundColor = marmitaIsTurnedOn ? UIColor.marGreen : UIColor.marRed
        turnOnButton.setTitle(marmitaIsTurnedOn ? "DESLIGAR" : "LIGAR", for: UIControl.State.normal)
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
        marmitaIsTurnedOn = !marmitaIsTurnedOn
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


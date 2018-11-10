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

    @IBOutlet weak var turnOnSwitch: UISwitch!
    @IBOutlet weak var soundSegmentedControl: UISegmentedControl!
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    var marmita: Marmita! {
        didSet {
            refreshUI()
        }
    }
    
    let sounds = ["padrao", "fabeo", "zap"]
    
    // MARK: view setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarmita()
        setupListeners()
        setupUI()
    }
    
    // MARK: setup
    
    private func setupUI() {
        turnOnSwitch.transform = CGAffineTransform(scaleX: 5, y: 5)
        refreshUI()
    }
    
    private func setupMarmita() {
        self.marmita = Marmita(dict: [
            "armada": false,
            "gemido": "",
            "gemendo": false
            ])
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
    
    // MARK: database
    
    private func synchronizeMarmita() {
        let database = Firestore.firestore()
        database.collection("marmitas").document("the_marmita").setData(self.marmita.toAnyObject()) { (error) in
            if let error = error {
                print("Error writing marmita: \(error)")
            } else {
                print("Marmita successfully written!")
            }
        }
    }
    
    // MARK: helpers
    
    private func refreshUI() {
        turnOnSwitch.setOn(marmita.armada, animated: true)
        soundSegmentedControl.selectedSegmentIndex = sounds.index(of: marmita.gemido) ?? 0
    }
    
    // MARK: actions
    
    @IBAction func didChangeTurnOnSwitch(_ sender: UISwitch) {
        self.marmita.armada = sender.isOn
        synchronizeMarmita()
    }
    
    @IBAction func didChangeSoundSegmentedControl(_ sender: UISegmentedControl) {
        self.marmita.gemido = sounds[sender.selectedSegmentIndex]
        synchronizeMarmita()
    }
}

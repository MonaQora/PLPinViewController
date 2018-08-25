//
//  PLExampleViewController.swift
//  PLPinViewController_Example
//
//  Created by Ash Thwaites on 25/08/2018.
//  Copyright © 2018 Ash Thwaites. All rights reserved.
//

import UIKit
import PLPinViewController

class PLExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentPinController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func alertPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "test PIN above alert", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changePinPressed(_ sender: Any) {
        let pinItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "apppin", accessGroup: KeychainConfiguration.accessGroup)
        if let _ = try? pinItem.readPassword() {
            PLPinViewController.show(with: .change, enableCancel: true, pinLength:5 , delegate: self, animated: true)
        }else{
            PLPinViewController.show(with: .create, enableCancel: false, pinLength:5 , delegate: self, animated: true)
        }
    }
    
    func presentPinController(){
        // if we dont have a pin then present create.. if we do then present pin check
        let pinItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "apppin", accessGroup: KeychainConfiguration.accessGroup)
        if let _ = try? pinItem.readPassword() {
            PLPinViewController.show(with: .enter, enableCancel: false, pinLength:5 , delegate: self, animated: true)
        }else{
            PLPinViewController.show(with: .create, enableCancel: false, pinLength:5 , delegate: self, animated: true)
        }
    }
}


// MARK: - Pin View Delegate
extension PLExampleViewController: PLPinViewControllerDelegate {
    
    func pinViewController(_ controller: PLPinViewController!, didSetPin pin: String!) {
        do {
            let pinItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "apppin", accessGroup: KeychainConfiguration.accessGroup)
            try pinItem.savePassword(pin)
            PLPinViewController.dismiss()
        }
        catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    
    func pinViewController(_ controller: PLPinViewController!, didEnterPin pin: String!) {
        PLPinViewController.dismiss()
    }
    
    
    func pinViewController(_ controller: PLPinViewController!, shouldAcceptPin pin: String!) -> Bool {
        let pinItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "apppin", accessGroup: KeychainConfiguration.accessGroup)
        if let correctPin = try? pinItem.readPassword() {
            return (pin == correctPin)
        }
        return false
    }
    
    
    func pinViewControllerDidLogout(_ controller: PLPinViewController!) {
        do {
            let pinItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: "apppin", accessGroup: KeychainConfiguration.accessGroup)
            try pinItem.deleteItem()
            PLPinViewController.dismiss()
        }
        catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    func pinViewControllerDidCancel(_ controller: PLPinViewController!) {
        PLPinViewController.dismiss()
    }

}




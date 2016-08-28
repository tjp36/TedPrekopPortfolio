//
//  SettingsViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

//This class is responsible for controlling the settings

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var billableRate: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the user settings from NSUser defaults
        User.sharedInstance.loadValues()
        
        //Fill in the text fields with the stored settings
        firstName.text = User.sharedInstance.firstName
        lastName.text = User.sharedInstance.lastName
        email.text = User.sharedInstance.email
        phoneNumber.text = User.sharedInstance.phoneNumber
        billableRate.text = String(format: "%.2f",User.sharedInstance.rate!)
        
        //Assign delegates
        firstName.delegate = self
        lastName.delegate = self
        billableRate.delegate = self
        email.delegate = self
        phoneNumber.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        /// Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        billableRate.resignFirstResponder()
    }
    
    // MARK: Actions
    
    //Save the user settings and dismiss the view controller
    @IBAction func saveSettings(sender: AnyObject) {
        
        User.sharedInstance.firstName = firstName.text
        User.sharedInstance.lastName = lastName.text
        User.sharedInstance.email = email.text
        User.sharedInstance.phoneNumber = phoneNumber.text
        User.sharedInstance.rate = Double(billableRate.text!)
        
        User.sharedInstance.saveValues()
        print(User.sharedInstance.firstName)
        print(User.sharedInstance.lastName)
        print(User.sharedInstance.email)
        print(User.sharedInstance.phoneNumber)
        print(User.sharedInstance.rate)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

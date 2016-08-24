//
//  SettingsViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var billableRate: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.sharedInstance.loadValues()
        
        firstName.text = User.sharedInstance.firstName
        lastName.text = User.sharedInstance.lastName
        email.text = User.sharedInstance.email
        phoneNumber.text = User.sharedInstance.phoneNumber
        billableRate.text = String(format: "%.2f",User.sharedInstance.rate!)
        
        
        print(User.sharedInstance)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Actions
    @IBAction func saveSettings(sender: AnyObject) {
        
        User.sharedInstance.firstName = firstName.text
        
        User.sharedInstance.lastName = lastName.text
        User.sharedInstance.email = email.text
        User.sharedInstance.phoneNumber = phoneNumber.text
        
        User.sharedInstance.rate = Double(billableRate.text!)
        
        User.sharedInstance.saveValues()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

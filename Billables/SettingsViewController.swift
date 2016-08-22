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
        
        if let savedSettings = loadSettings(){
            firstName.text = savedSettings.firstName
            lastName.text = savedSettings.lastName
            email.text = savedSettings.email
            phoneNumber.text = savedSettings.phoneNumber
            billableRate.text = String(savedSettings.rate)
        }
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
        saveSettings1()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: NSCoding
    func saveSettings1(){
        /// Code to save meals so that same meals are there when we restart app
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( User.sharedInstance  , toFile: User.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save settings...")
        }
    }
    
    ///Code to load the meals when we start up app
    func loadSettings() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
    
    
    
}

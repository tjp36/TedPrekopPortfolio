//
//  MatterDetailViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit
import MessageUI

class MatterDetailViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    // MARK: Properties
    var matter: Matter?
    var counter: Int = 0
    
   
    
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerLabelDecimal: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatterDetailViewController.appEnteredBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        counter = TimerSingleton.sharedInstance.counter
        timerLabel.text = "\(counter)"
        
        descriptionTextField.delegate = self
        TimerSingleton.sharedInstance.delegate = self
        
        if let matter = matter{
            navigationItem.title = matter.client
            descriptionTextField.text = matter.desc
        }

      
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        /// Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        /// Disable the Save button while editing.
        saveButton.enabled = false
    }
    
//    func checkValidMealName() {
//        /// Disable the Save button if the text field is empty.
//        let text = nameTextField.text ?? ""
//        saveButton.enabled = !text.isEmpty
//    }
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        ///Validate
//        checkValidMealName()
//        navigationItem.title = textField.text
//    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(saveButton === sender){
            let client = "test"
            let desc = descriptionTextField.text ?? ""
            let time = Double(timerLabelDecimal.text!)
            let price = (100.00 * time!).roundToPlaces(2)
            matter = Matter(client: client, desc: desc, time: time!, price: price)
        }
        
    
    }

    // MARK: Actions
    @IBAction func startTimer(sender: AnyObject) {
          
        TimerSingleton.sharedInstance.start()
        saveButton.enabled = false
        
    }
    
    
    @IBAction func stopTimer(sender: AnyObject) {
        let test = Double(TimerSingleton.sharedInstance.counter + 12)
        print(test)
        let decTime = (Double) (   test / 60).roundToPlaces(1)
        print(decTime)
        TimerSingleton.sharedInstance.stop()
        
        timerLabelDecimal.text = "\(decTime)"
        saveButton.enabled = true
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["theodore.prekop@gmail.com"])
            mail.setMessageBody("Client:  \(matter?.client)\n" +
                                "Description:  \(matter?.desc)\n" +
                                "Time:  \(matter!.time)" +
                                "Price:  \(matter?.price)", isHTML: false)
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            print("send email not available")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        /// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
    
    func appEnteredBackground(notification:NSNotification) {
        TimerSingleton.sharedInstance.enteredBackground()
    }
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

extension MatterDetailViewController: TimerLabelDelegate{
    func updateLabel(counter: Int) {
        print(counter)
        timerLabel.text = String(counter)
    }
}

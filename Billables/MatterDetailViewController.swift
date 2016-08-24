//
//  MatterDetailViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit
import MessageUI

class MatterDetailViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate{

    // MARK: Properties
    var matter: Matter?
    var client: Client?
    var counterHour: Int = 0
    var counterMinute: Int = 0
    var counterSecond: Int = 0
    var clientName: String?
    var totalTime: Double = 0.0
    
   
    
   
   
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var navLabel: UINavigationItem!

    @IBOutlet weak var timerLabelHour: UILabel!
    @IBOutlet weak var timerLabelMinute: UILabel!
    @IBOutlet weak var timerLabelSecond: UILabel!
    @IBOutlet weak var timerLabelDecimal: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.sharedInstance.loadValues()
        
        navLabel.title = clientName
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatterDetailViewController.appEnteredBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatterDetailViewController.appReturnedFromBackground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
       
        timerLabelHour.text = "\(counterHour):"
        timerLabelMinute.text = "\(counterMinute):"
        timerLabelSecond.text = "\(counterSecond)"
        
        
        descriptionTextField.delegate = self
        TimerSingleton.sharedInstance.delegate = self
        
        if let matter = matter{
            navigationItem.title = matter.client?.name
            descriptionTextField.text = matter.desc
        }
      
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        /// Disable the Save button while editing.
        //saveButton.enabled = false
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
            
            let desc = descriptionTextField.text ?? ""
            if(totalTime <= 0){
                totalTime = 0.1
            }
            let time = Double(timeField.text!)
            let price = (User.sharedInstance.rate! * time!).roundToPlaces(2)
            let date = datePicker.date
            
            matter = Matter(client: self.client!, desc: desc, time: time!, price: price, date: date)
        }
        
    
    }

    // MARK: Actions
    @IBAction func startTimer(sender: AnyObject) {
         // print(TimerSingleton.sharedInstance)
        TimerSingleton.sharedInstance.start()
        saveButton.enabled = false
        
    }
    
    
    @IBAction func stopTimer(sender: AnyObject) {
        let hours =  Double(counterHour)
        let minutes = Double(counterMinute)
        totalTime = (hours + (minutes / 60)).roundToPlaces(1)
       
        
        
        TimerSingleton.sharedInstance.stop()
        
        timerLabelDecimal.text = "\(totalTime) hours"
        timeField.text = String(totalTime)
        saveButton.enabled = true
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([User.sharedInstance.email!])
            mail.setSubject("Bill for Client:  \(matter!.client!)")
            mail.setMessageBody("Client:  \(matter!.client!)\n" +
                                "Description:  \(matter!.desc!)\n" +
                                "Time:  \(matter!.time!)\n" +
                                "Price:  $\(matter!.price!)", isHTML: false)
            
          //  let json = try NSJSONSerialization.dataWithJSONObject(matter!, options: NSJSONWritingOptions.PrettyPrinted)
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
    
    func appReturnedFromBackground(notification:NSNotification){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let now = defaults.objectForKey("StartDate") as! NSDate
        
        let currentTime = -1 * Int(now.timeIntervalSinceNow)
        
        counterHour = currentTime / 3600
        counterMinute = currentTime / 60
        while(counterMinute > 60){
            counterMinute -= 60
            if(counterMinute < 0){
                counterMinute += 60
            }
        }
        while(counterSecond >= 60){
            counterSecond -= 60
            if(counterSecond < 0){
                counterSecond += 60
            }
        }
        
       // print("Counter is \(counterSecond)")
        
        timerLabelHour.text = "\(counterHour):"
        timerLabelMinute.text = "\(counterMinute):"
        timerLabelSecond.text = "\(counterSecond)"
        
        TimerSingleton.sharedInstance.returnedFromBackground()
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
        var counter1 = counter
        
        if(counter1 == 60){
            counter1 = 0
            counterMinute += 1
            counterSecond = 0
            timerLabelMinute.text = "\(counterMinute):"
            timerLabelSecond.text = "\(counterSecond)"
        }
        if(counterMinute == 60){
            counterMinute = 0
            timerLabelMinute.text = "\(counterMinute):"
            counterHour += 1
            timerLabelHour.text = "\(counterHour):"
        }
        timerLabelSecond.text = "\(counter1)"
    }
}

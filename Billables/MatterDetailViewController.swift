//
//  MatterDetailViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is responsible for visually displaying the timer status, sending emails, and adding desciptions to matters
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
        
        //Load the User settings for later use
        User.sharedInstance.loadValues()
        
        //Set the Label equal to the client name
        navLabel.title = clientName
        
        //Add observers from NSNotificationCenter that will call functions whennever the application enters or returns from a background state
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatterDetailViewController.appEnteredBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatterDetailViewController.appReturnedFromBackground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
       
        //Set the timer values
        timerLabelHour.text = "\(counterHour):"
        timerLabelMinute.text = "\(counterMinute):"
        timerLabelSecond.text = "\(counterSecond)"
        
        //Set up delegates
        descriptionTextField.delegate = self
        timeField.delegate = self
        TimerSingleton.sharedInstance.delegate = self
        
        //If we are viewing an existing matter, set the name and description equal to the existing matters values
        if let matter = matter{
            navigationItem.title = matter.client?.name
            descriptionTextField.text = matter.desc
        }
        
        let btnTempStop = self.view.viewWithTag(2) as! UIButton;
        btnTempStop.enabled = false;
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    //Remove observer when needed
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        timerLabelDecimal.text = timeField.text!
        timeField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    //Function called upon pressing save
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(saveButton === sender){
            
            let desc = descriptionTextField.text ?? ""
            
            //Round up to prevent saving tasks with 0 time
            if(totalTime <= 0){
                totalTime = 0.1
            }
            
            let time = Double(timeField.text!)
            let price = (User.sharedInstance.rate! * time!).roundToPlaces(2)
            let date = datePicker.date
            
            //Create a new matter from the values in the fields of the TextFields and the User settings
            matter = Matter(client: self.client!, desc: desc, time: time!, price: price, date: date)
            print(matter)
        }
    }

    // MARK: Actions
    
    //Function to be called when the Start button is pressed.  Starts a timer and disables save button
    @IBAction func startTimer(sender: AnyObject) {
        let btnTemp = self.view.viewWithTag(1) as! UIButton;
        btnTemp.enabled = false;
        let btnTempStop = self.view.viewWithTag(2) as! UIButton;
        btnTempStop.enabled = true;
        TimerSingleton.sharedInstance.start()
        saveButton.enabled = false
    }
    
    //Function to be called when the Stop button is pressed.  Stops the timer, calculates the elapsed time, updates labels, and reenables the save button
    @IBAction func stopTimer(sender: AnyObject) {
        let hours =  Double(counterHour)
        let minutes = Double(counterMinute)
        totalTime = (hours + (minutes / 60)).roundToPlaces(1)
       
        TimerSingleton.sharedInstance.stop()
        
        timerLabelDecimal.text = "\(totalTime) hours"
        timeField.text = String(totalTime)
        saveButton.enabled = true
        let btnTemp = self.view.viewWithTag(1) as! UIButton;
        btnTemp.enabled = true;
        let btnTempStop = self.view.viewWithTag(2) as! UIButton;
        btnTempStop.enabled = false;
    }
    
    //Sends an email with the matter details to an email address saved in Settings
    @IBAction func sendEmail(sender: AnyObject) {
        
        //Check to see if User has entered his/her settings.  If not, do not send emil and return
        if(User.sharedInstance.email == nil || User.sharedInstance.rate == nil){
            
            let alert = UIAlertController(title: "User Settings Not Set", message: "Please go to Settings and set your user profile to use this feature", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if(matter == nil){
            let alert = UIAlertController(title: "Matter Not Yet Saved", message: "Please save this matter before emailing", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        //Check to see if mail can be sent.  If yes, send an email with the pertinent matter details
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([User.sharedInstance.email!])
            mail.setSubject("Bill for Client:  \(matter!.client!.name!)")
            mail.setMessageBody("Client:  \(matter!.client!.name!)\n" +
                                "Description:  \(matter!.desc!)\n" +
                                "Time:  \(matter!.time!)\n" +
                "Price:  $" + String(format:"%.2f", matter!.price!), isHTML: false)
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            print("Send email not available")
        }
    }
    
    //Called when MFMailComposeViewController is dismissed
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        /// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMatterMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMatterMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    //Called by NSNotificationCenter whennever application enters background
    func appEnteredBackground(notification:NSNotification) {
        TimerSingleton.sharedInstance.enteredBackground()
    }
    
    //Called by NSNotificationCenter whennever app returns from background
    func appReturnedFromBackground(notification:NSNotification){
        
        //Get the total elapsed time since the Start button was pressed (in seconds)
        let defaults = NSUserDefaults.standardUserDefaults()
        let now = defaults.objectForKey("StartDate") as! NSDate
        let currentTime = -1 * Int(now.timeIntervalSinceNow)
        
        //Obtain the current elapsed hour(s)
        counterHour = currentTime / 3600
        
        //Obtain the current elapsed minutes by dividing by currentTime by 60 and then subtracting until we have a value that can "fit" into the counterMinute label
        counterMinute = currentTime / 60
        while(counterMinute > 60){
            counterMinute -= 60
            if(counterMinute < 0){
                counterMinute += 60
            }
        }
        
        //Subtract 60 seconds from the counterSecond until we have a value that can "fit" into the counterSecond label
        while(counterSecond >= 60){
            counterSecond -= 60
            if(counterSecond < 0){
                counterSecond += 60
            }
        }
        
        //Update the lables
        timerLabelHour.text = "\(counterHour):"
        timerLabelMinute.text = "\(counterMinute):"
        timerLabelSecond.text = "\(counterSecond)"
        
        //Restart the timer
        TimerSingleton.sharedInstance.returnedFromBackground()
    }

}

/// Extension that rounds the double to decimal places value
extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

//Function called by delegate that updates the labels in this view controller
extension MatterDetailViewController: TimerLabelDelegate{
    func updateLabel(counter: Int) {
        var counter1 = counter

        //When counter1 is 60, we need to reset to counterSecond to 0 and increment the minutes
        if(counter1 == 60){
            counter1 = 0
            counterMinute += 1
            counterSecond = 0
            timerLabelMinute.text = "\(counterMinute):"
            timerLabelSecond.text = "\(counterSecond)"
        }
        
        //If counter minute is 60, we need to reset to 0 and increment the hour
        if(counterMinute == 60){
            counterMinute = 0
            timerLabelMinute.text = "\(counterMinute):"
            counterHour += 1
            timerLabelHour.text = "\(counterHour):"
        }
        timerLabelSecond.text = "\(counter1)"
    }
}

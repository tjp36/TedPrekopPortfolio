//
//  TimerSingleton.swift
//  Billables
//
//  Created by Theodore Prekop on 8/20/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is responsible for maintaining the timer

import Foundation

//Delegate protocol that allows this class to communicate with MaterDetailViewController so that its labels can be updated
protocol TimerLabelDelegate: class{
    func updateLabel(counter: Int) -> Void
}

class TimerSingleton{
    static let sharedInstance = TimerSingleton()
    
    //MARK: - Properties
    var startTime: NSDate?
    var endTime: NSDate?
    var enteredBackgroundTime: NSDate?
    var timer: NSTimer?
    weak var delegate: TimerLabelDelegate?
   
    var counter: Int = 0
    var isTimerRunning: Bool = false
    
    private init(){}
    
    //Starts the timer and saves its start Date to NSUserDefaults
    func start(){
        isTimerRunning = true
        startTime = NSDate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(startTime, forKey: "StartDate")
        defaults.setBool(isTimerRunning, forKey: "isTimerRunning")
        
        //initialize timer and call timerAction every 1.0 second
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func checkReturnStatus() -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey("isTimerRunning")
    }
    
    //Increments the counter and updates the label in MatterDetailViewController using the delegate object
    @objc func timerAction(){
        counter += 1
        self.delegate?.updateLabel(counter)
        
        //If the counter is 60, reset to 0
        if(counter == 60){
            counter = 0
        }
    }
    
    //Stops the timer, invalides it, and resets the counter
    func stop(){
        isTimerRunning = false
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(isTimerRunning, forKey: "isTimerRunning")
        endTime = NSDate()
        timer?.invalidate()
        counter = 0
    }
    
    //Func to be called when Timer enters backgrounds
    func enteredBackground(){
        timer?.invalidate()
    }
    
    //Func to be called when Timer returns from background.
    func returnedFromBackground(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let now = defaults.objectForKey("StartDate") as! NSDate
        var currentTime = -1 * Int(now.timeIntervalSinceNow)
        
        //While the current time is more than 60, substract 60 until we get the counter to the right value and set counter equal to value
        while(currentTime >= 60){
            currentTime -= 60
        }
       counter = currentTime
        
       //Start timer again
       timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
}


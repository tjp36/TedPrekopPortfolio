//
//  TimerSingleton.swift
//  Billables
//
//  Created by Theodore Prekop on 8/20/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import Foundation

class TimerSingleton{
    static let sharedInstance = TimerSingleton()
    
    var startTime: NSDate?
    var endTime: NSDate?
    var enteredBackgroundTime: NSDate?
    var timer: NSTimer?
    var counter: Int = 0
    var isTimerRunning: Bool = false
    
    private init(){}
    
    func start(){
        isTimerRunning = true
        startTime = NSDate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(startTime, forKey: "StartDate")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        counter += 1
    }
    
    func stop(){
        isTimerRunning = false
        endTime = NSDate()
        timer?.invalidate()
        counter = 0
    }
    
    func enteredBackground(){
        enteredBackgroundTime = NSDate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(enteredBackgroundTime, forKey: "EnteredBackgroundDate")
    }
    
    func returnedFromBackground(){
        let currentTime = Int((enteredBackgroundTime?.timeIntervalSinceNow)!)
        counter = currentTime

    }
    
}
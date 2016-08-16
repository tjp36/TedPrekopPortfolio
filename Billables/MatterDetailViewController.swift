//
//  MatterDetailViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class MatterDetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerLabelDecimal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func startTimer(sender: AnyObject) {
    }
    
    @IBAction func stopTimer(sender: AnyObject) {
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
    }
    
}

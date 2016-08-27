//
//  ShowSplashViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/27/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class ShowSplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(#selector(ShowSplashViewController.showNavController), withObject: nil, afterDelay: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNavController(){
        performSegueWithIdentifier("showSplash", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

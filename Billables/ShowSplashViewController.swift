//
//  ShowSplashViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/27/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is responsible for showing the splash screen of the application

import UIKit

class ShowSplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Show splash screen for 2 seconds
        performSelector(#selector(ShowSplashViewController.showNavController), withObject: nil, afterDelay: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show the splash screen 
    func showNavController(){
        performSegueWithIdentifier("showSplash", sender: self)
    }

}

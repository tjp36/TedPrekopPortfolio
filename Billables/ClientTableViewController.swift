//
//  ClientTableViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class ClientTableViewController: UITableViewController {
    
    // MARK: Properties
    var clients = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If this is the 5th launch, show the Rate Me alert
        if(NSUserDefaults.standardUserDefaults().integerForKey("HasLaunchedFiveTimes") == 5){
            showRatingAlert()
        }
        
        /// Load any saved clients, otherwise load the sample clients
        if let savedClients = loadClients() {
            clients = savedClients
        }
        else {
            /// Load the sample data.
            loadSampleClients()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadSampleClients(){
        let photo1 = UIImage(named: "client1")
        let matters1 = [Matter]()
        let client1 = Client(name: "Sherwin Williams", photo: photo1, matters: matters1)
        
        let matters2 = [Matter]()
        let photo2 = UIImage(named: "client2")
        let client2 = Client(name: "University of Chicago", photo: photo2, matters: matters2)
        
        let matters3 = [Matter]()
        let photo3 = UIImage(named: "client3")
        let client3 = Client(name: "Twitter", photo: photo3, matters: matters3)
        
        clients.append(client1!)
        clients.append(client2!)
        clients.append(client3!)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "clientCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ClientTableViewCell
        let client = clients[indexPath.row]
        
        //Set client name and photo for each cell
        cell.client.text = client.name
        cell.clientImage.image = client.photo
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
     // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        }
     }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if(segue.identifier == "showMatters"){
    
            let matterTableViewController = (segue.destinationViewController as! UINavigationController).topViewController as! MatterTableViewController
            if let selectedClientCell = sender as? ClientTableViewCell{
                
                let indexPath = tableView.indexPathForCell(selectedClientCell)
                let selectedClient = clients[indexPath!.row]
                
                //Set the client equal to the client represented in the selected cell
                matterTableViewController.navLabel.title = selectedClient.name
                matterTableViewController.client = selectedClient
                saveClients()
            }
        }
    }
    
    //After returning from the AddClientViewController, append the new client to clients array and save
    @IBAction func unwindToClientList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddClientViewController, client = sourceViewController.client {
                let newIndexPath = NSIndexPath(forRow: clients.count, inSection: 0)
                clients.append(client)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            saveClients()
        }
    }
    
    //Alert controller to be displayed upon the 5th launch of the application
    func showRatingAlert(){
        let alert = UIAlertController(title: "Rate Me", message: "Thanks for using Billables", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Rate the App", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: NSCoding
    func saveClients(){
        /// Code to save clients so that same clients are there when we restart app
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clients, toFile: Client.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save clients...")
        }
        else{
            print("saved client")
        }
    }
    
    ///Code to load the clients when we start up app
    func loadClients() -> [Client]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Client.ArchiveURL.path!) as? [Client]
    }
}

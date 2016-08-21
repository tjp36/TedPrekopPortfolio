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

        /// Load any saved meals, otherwise load sample data.
        if let savedClients = loadClients() {
            clients += savedClients
        }
        else {
            /// Load the sample data.
            loadSampleClients()
        }
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showMatters"){
            
            let matterTableViewController = (segue.destinationViewController as! UINavigationController).topViewController as! MatterTableViewController
            
            if let selectedClientCell = sender as? ClientTableViewCell{
                print(selectedClientCell)
                let indexPath = tableView.indexPathForCell(selectedClientCell)
                let selectedClient = clients[indexPath!.row]
                
                matterTableViewController.navLabel.title = selectedClient.name
                print(selectedClient.name)
                
                matterTableViewController.matters = selectedClient.matters
            }
            
        }
    }
    
    @IBAction func unwindToClientList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddClientViewController, client = sourceViewController.client {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                /// Update an existing meal.
//                clients[selectedIndexPath.row] = client
//                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
//            }
            //else {
                /// Add a new meal.
                let newIndexPath = NSIndexPath(forRow: clients.count, inSection: 0)
                clients.append(client)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
           // }
            /// Save the meals.
            saveClients()
        }
    }
    
    // MARK: NSCoding
    func saveClients(){
        /// Code to save meals so that same meals are there when we restart app
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clients, toFile: Client.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save clients...")
        }
    }
    
    ///Code to load the meals when we start up app
    func loadClients() -> [Client]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Client.ArchiveURL.path!) as? [Client]
    }
 

}

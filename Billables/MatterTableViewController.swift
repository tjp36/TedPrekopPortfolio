//
//  MatterTableViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is responible for controlling the Matters table of the client

import UIKit

class MatterTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var navLabel: UINavigationItem!
    var client: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return client!.matters.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "matterCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatterTableViewCell
        
        let matter = client?.matters[indexPath.row]
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        
        //Set the elements of the cell
        cell.client.text = matter!.client?.name
        cell.desc.text = matter!.desc
        cell.time.text = "\(matter!.time!.roundToPlaces(1)) hours"
        cell.date.text = formatter.stringFromDate((matter?.date)!)
    
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

    // MARK: - Action
    @IBAction func back(sender: UIBarButtonItem) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDetail"){
            let matterDetailViewController = segue.destinationViewController as! MatterDetailViewController
            if let selectedMatterCell = sender as? MatterTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMatterCell)
                let selectedMatter = client!.matters[indexPath!.row]
                
                //Set the matter and client of the MatterDetailViewController
                matterDetailViewController.matter = selectedMatter
                matterDetailViewController.client = client!
            }
        }
        else if segue.identifier == "addMatter" {
            //Set the matter and client of the MatterDetailViewController
            let matterDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! MatterDetailViewController
            matterDetailViewController.client = self.client
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MatterDetailViewController, matter = sourceViewController.matter{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //Update an exsting matter
                client!.matters[selectedIndexPath.row] = matter
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else{
                //Add a new matter
                let newIndexPath = NSIndexPath(forRow: client!.matters.count, inSection: 0)
                client!.matters.append(matter)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
        saveMatters()
    }
    
    //This function saves the matters to the current client
    func saveMatters(){
        
        //Find the current client from the saved clients.  Update that client with the client in the App's memory
        var clientAry = NSKeyedUnarchiver.unarchiveObjectWithFile(Client.ArchiveURL.path!) as? [Client]
        for (index, client) in clientAry!.enumerate(){
            if client.name == self.client!.name{
                clientAry![index] = self.client!
            }
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clientAry!, toFile: Client.ArchiveURL.path!)
        
        if !isSuccessfulSave{
            print("Failed to save matter")
        }
        else{
            print("saved matter to \(Matter.ArchiveURL.path!)")
        }
    }

}

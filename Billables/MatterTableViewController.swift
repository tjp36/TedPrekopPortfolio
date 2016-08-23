//
//  MatterTableViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class MatterTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var navLabel: UINavigationItem!
    //var matters = [Matter]()
    var clientName: String?
    var client: Client?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedMatters = loadMatters() {
            client!.matters = savedMatters
        }
        else {
            /// Load the sample data.
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.client.text = matter!.client
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDetail"){
            let matterDetailViewController = segue.destinationViewController as! MatterDetailViewController
            if let selectedMatterCell = sender as? MatterTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMatterCell)
                let selectedMatter = client!.matters[indexPath!.row]
                matterDetailViewController.matter = selectedMatter
                
            }
        }
        else if segue.identifier == "addMatter" {
           
            let matterDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! MatterDetailViewController
            matterDetailViewController.clientName = self.clientName
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
    
    func saveMatters(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(client!.matters, toFile: Matter.ArchiveURL.path! + "\(clientName)")
        if !isSuccessfulSave{
            print("Failed to save matter")
        }
    }
    
    ///Code to load the meals when we start up app
    func loadMatters() -> [Matter]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Matter.ArchiveURL.path! + "\(clientName)") as? [Matter]
    }
 

}

//
//  MatterTableViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class MatterTableViewController: UITableViewController {
    
    @IBOutlet weak var navLabel: UINavigationItem!
    var matters = [Matter]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return matters.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "matterCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatterTableViewCell
        
        let matter = matters[indexPath.row]
        
        cell.client.text = matter.client
        cell.desc.text = matter.desc
        cell.time.text = String(matter.time)
        
        

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
        if(segue.identifier == "showDetail"){
            let matterDetailViewController = segue.destinationViewController as! MatterDetailViewController
            if let selectedMatterCell = sender as? MatterTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMatterCell)
                let selectedMatter = matters[indexPath!.row]
                matterDetailViewController.matter = selectedMatter
                
            }
        }
        else if segue.identifier == "addMatter" {
            print("Adding new matter.")
        }
        
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MatterDetailViewController, matter = sourceViewController.matter{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //Update an exsting matter
                matters[selectedIndexPath.row] = matter
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else{
                //Add a new matter
                let newIndexPath = NSIndexPath(forRow: matters.count, inSection: 0)
                matters.append(matter)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
        saveMatters()
    }
    
    func saveMatters(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(matters, toFile: Matter.ArchiveURL.path!)
        if !isSuccessfulSave{
            print("Failed to save matter")
        }
    }
 

}

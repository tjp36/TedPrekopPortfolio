//
//  MatterTableViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is responible for controlling the Matters table of the client

import UIKit

class MatterTableViewController: UITableViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var navLabel: UINavigationItem!
    var client: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MatterTableViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 5.0
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.tableView.addGestureRecognizer(lpgr)
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
    
    //Long press gesture recognizer to handle deletions
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizerState.Ended){
            return
        }
        
        let touchPoint = gestureRecognizer.locationInView(self.view)
        if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
            confirmDelete(indexPath)
        }
        
    }
    
    //Alert Controller to handle deletions
    func confirmDelete(indexPath: NSIndexPath){
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this matter?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.client!.matters.removeAtIndex(indexPath.row)
            self.saveMatters()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

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
                
                print(matterDetailViewController.matter)
                print(matterDetailViewController.client)
            }
        }
        else if segue.identifier == "addMatter" {
            //Set the matter and client of the MatterDetailViewController
            let matterDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! MatterDetailViewController
            matterDetailViewController.client = self.client
            print(matterDetailViewController.client)
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

//
//  AdvancedSetupTableViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/6/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Alamofire

class AdvancedSetupTableViewController: UITableViewController {

    
    @IBOutlet weak var serverTextView: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    
    @IBAction func continueButton(sender: AnyObject)
    {
        
        let url = "\(self.serverTextView.text!)/wp-json"
        
        spinner.hidden = false
        spinner.startAnimating()
        
        Alamofire.request(.GET, url)
            .validate()
            .responseJSON { response in
                
                switch response.result
                {
                case .Success:
                    print("Validation Successful")
                    
                    NSUserDefaults.standardUserDefaults().setObject("checked", forKey: "server")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    NSUserDefaults.standardUserDefaults().setObject(url, forKey: "serverurl")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.performSegueWithIdentifier("SegueDevices", sender: self)
                    
                    break
                case .Failure(let error):
                    print(error)
                    
                    self.spinner.stopAnimating()
                    self.spinner.hidden = false
                    
                    let message = "No valid server found on the given url. Pleasee check the installation guide and try again."
                    
                    let alert = UIAlertController(title: "Server not found", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.spinner.hidden = false
                    
                    
                    
                    break
                }
            
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SetupCameraTableViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 3/5/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit

class SetupCameraTableViewController: UITableViewController {

    var devices = [Device]()

    override func viewDidLoad() 
    {
        super.viewDidLoad()        

        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int 
    {
        return self.devices.count
    }

    func reload()
    {
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.lightGrayColor()
        headerView.tag = section
        
        let title = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-10, height: 30)) as UILabel
        
        title.text = self.devices[section].hostname// sectionTitleArray.objectAtIndex(section) as? String
        
        headerView.addSubview(title)

        var headBttn:UIButton = UIButton(type: UIButtonType.System)
        headBttn.translatesAutoresizingMaskIntoConstraints = false
        headBttn.enabled = true
        headBttn.frame = CGRectMake(0, 0, 40, 40)
        let image = UIImage(named: "checkmark-50") as UIImage?
        headBttn.setImage(image, forState: .Normal)
        headBttn.addTarget(self, action: "checkCategories:", forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.addSubview(headBttn)
        
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["title"] = title
        viewsDict["headBttn"] = headBttn

        headerView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(
           "H:|-10-[title]-[headBttn]-15-|", options:  NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        headerView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[title]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))

        headerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[headBttn]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))

        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }

    func checkCategories(sender:UIButton)
    {
        if (sender.tag == 5)
        {

        }        
    }

    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        
            print("Tapping working")
            print(recognizer.view?.tag)
            
            let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
            if (indexPath.row == 0) 
            {
                var collapsed = self.devices[indexPath.section].collapsed
                    
                if (collapsed)
                {
                    self.devices[indexPath.section].collapsed = false
                } else {
                    self.devices[indexPath.section].collapsed = true
                }
 
                //reload specific section animated
                let range = NSMakeRange(indexPath.section, 1)
                let sectionToReload = NSIndexSet(indexesInRange: range)
                self.tableView.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)

            }            
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.devices.count == 0
        {
            return 0
        } else
        {
            let count = self.devices.count
            print(count)
            return count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DeviceTableViewCell
        if cell == nil
        {
            print("null")
        }

        if self.devices[indexPath.row].joined
        {
            cell!.statusLabel?.text = "Joined"
            
            if self.devices[indexPath.row].running
            {
               cell!.statusImage.image = UIImage(named: "camerarunning")    
            } else 
            {
                cell!.statusImage.image = UIImage(named: "cameraon")    
            }

        } else 
        {
            cell!.statusLabel?.text = "Unjoined"

            cell!.statusImage.image = UIImage(named: "camerano")    

        }
        
        cell!.textLabel?.text = self.devices[indexPath.row].ipnumber
        
        return cell!

    }

  
    
    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning() 
    }

}

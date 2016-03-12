//
//  SetupCameraTableViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 3/5/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse



class SetupCameraTableViewContrsoller: UITableViewController,
SocketProtocolDelegate 
{

    var devices = [Device]()

    var socket = Socket()

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() 
    {
        super.viewDidLoad()        

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.configureTableView() 

        self.socket.delegate = self

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int 
    {
        return self.devices.count
    }

    func reload()
    {
        self.tableView.reloadData()
    }

    func configureTableView() 
    {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75.0
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 80))
        headerView.backgroundColor = UIColor.lightGrayColor()
        headerView.tag = section
        
        let ipnumber = UILabel(frame: CGRect(x: 5, y: 5, width: 200, height: 30)) as UILabel
        ipnumber.text = self.devices[section].ipnumber
        ipnumber.font = ipnumber.font.fontWithSize(30)
        ipnumber.font = UIFont.boldSystemFontOfSize(20.0)
        headerView.addSubview(ipnumber)

        let title = UILabel(frame: CGRect(x: 5, y: 35, width: 200, height: 30)) as UILabel
        title.text = self.devices[section].hostname
        title.font = title.font.fontWithSize(13)
        headerView.addSubview(title)
        
        var iconstatus = String()
        var statustext = String()
        if self.devices[section].joined
        {
            statustext = "Joined"
            iconstatus = "checkmark-50"

        } else 
        {
            statustext = "Unjoined"
            iconstatus = "New-50"
        }

        let image = UIImage(named: iconstatus) as UIImage?
        let imageView = UIImageView(image: image!)
        let ximg = tableView.frame.size.width - 50
        imageView.frame = CGRect(x: ximg, y: 5, width: 40, height: 40)
        headerView.addSubview(imageView)

        let xsmg = tableView.frame.size.width - 100
        let status = UILabel(frame: CGRect(x: xsmg, y: 35, width: 100, height: 30)) as UILabel
        status.text = "status: \(statustext)"
        status.font = status.font.fontWithSize(13)
        headerView.addSubview(status)
        
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["title"] = title
        viewsDict["imageView"] = imageView

        /*headerView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(
           "H:|-10-[title]-[imageView]-10-|", options:  NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        headerView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[title]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))

        headerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[imageView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))*/

        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }

    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) 
    {
        
        print("Tapping working")
        print(recognizer.view?.tag)
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)

        if !self.devices[indexPath.section].joined
        {

            let message = "Would you like to join device \(self.devices[indexPath.section].hostname)?"

            let alert = UIAlertController(title: "Join device", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action -> Void in

                let query = PFQuery(className:"_User")
                query.whereKey("user", notEqualTo: PFUser.currentUser()!)
            
                query.findObjectsInBackgroundWithBlock {(userObjects:[PFObject]?, error: NSError?) -> Void in
                
                if error != nil
                {
                    print("error")
                    
                } else
                {

                     if let userArray = userObjects
                    {
                        
                        for quser in userArray
                        {
                            let _username = quser["username"] as! String
                            let _wp_user = quser["wp_user"] as! String
                            let _wp_password = quser["wp_password"] as! String
                            let _wp_server_url = quser["wp_server_url"] as! String
                            let _wp_userid = quser["wp_userid"] as! Int
                            let _wp_userid_ = Int32(_wp_userid) 
                            let _wp_client_id = quser["wp_client_id"] as! Int
                            let _wp_client_id_ = Int32(_wp_client_id)
                            let _wp_client_mediaid = quser["wp_client_media_id"] as! Int
                            let _wp_client_mediaid_ = Int32(_wp_client_mediaid)
                            let _email = quser["email"] as! String
                            let _first_name = quser["first_name"] as! String
                            let _last_name = quser["last_name"] as! String
                            let _location = quser["location"] as! PFGeoPoint

                            let deviceRelation  = quser["device"] as? PFRelation
                            
                            let queryDevice = deviceRelation!.query()
    
                            queryDevice.findObjectsInBackgroundWithBlock {(deviceobjects:[PFObject]?, error:
                                NSError?) -> Void in

                                if error != nil
                                {
                                    print("error")
                                } else {
                                
                                    if let deviceArray = deviceobjects
                                    {
                                        for device in deviceArray
                                        {


                                           

                                            let objectId = device.objectId! as String
                                            
                                            let uiidinstallation = device["uuid_installation"] as! String

                                            let deviceIp = device["ipaddress"] as! String

                                            let wpserverurl = (_wp_server_url as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                                            let wpserverurlbase64  = wpserverurl!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

                                            print("....................................")
                                            //print( "_username            :\(_username           )")
                                            print( "_wp_user             :\(_wp_user            )")
                                            print( "_wp_password         :\(_wp_password        )")
                                            print( "_wp_server_url       :\(_wp_server_url      )")
                                            print( "_wp_userid_          :\(_wp_userid_         )")
                                            print( "_wp_client_id_       :\(_wp_client_id_      )")
                                            print( "_wp_client_mediaid_  :\(_wp_client_mediaid_ )")
                                            print( "_email               :\(_email              )")
                                            print( "_first_name          :\(_first_name         )")
                                            print( "_last_name           :\(_last_name          )")
                                            print( "_location            :\(_location           )")
                                            print("....................................")   



                                            struct UserToProto 
                                            {
                                                var serverType = Int32()
                                                var type = Int32()
                                                var packagesize = Int32()
                                                var includethubmnails = Bool()
                                                var imagefilepath = String() 
                                            }

                                            
                                            let pfuser = Motion.Message_.MotionUser.Builder()
                                            //pfuser.setWpserverurl(wpserverurlbase64.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                                            pfuser.setWpuser("dlskfjlfdsfsldsajfadsfasdfasdlkjsdflkasjdflkjaslkjdflkajsdflkjaslkdfjlksajdflkdfsdfsdfdssdfskdfjl".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                                            //pfuser.setWppassword("fglkfgdd__asdfasdlkfjdsf_DFA_SDAfjlk".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                                            //pfuser.setWpclientid(40)
                                            //pfuser.setWpclientmediaid(222)


                                            
                                           //pfuser.setWpServerUrl("gfdgdfsgsdgsfgsdfgsdfg") //wpserverurlbase64)
                                            //pfuser.setuiidinstallation("UIID") //uiidinstallation)
                                            //spfuser.setwpuserid(33) //_wp_userid_)
                                            /*pfuser.setWpClientId(_wp_client_id_)
                                            pfuser.setWpClientMediaid(_wp_client_mediaid_)
                                            pfuser.setUsername(_username)
                                            pfuser.setEmail(_email)
                                            pfuser.setFirstName(_first_name)
                                            pfuser.setLastName(_last_name)
                                            pfuser.setLocation("\(_location.latitude) \(_location.longitude)")
                                            pfuser.setUiidinstallation(uiidinstallation)
                                            pfuser.setClientnumber(_wp_userid_)*/

                                            do
                                            {                            
                                                try message.motionuser += [pfuser.build()]
                                            } catch
                                            {
                                                print(error)
                                            }

                                            self.socket.deviceIp = deviceIp
                                            self.socket.setLocaladdrip(self.appDelegate.localaddrip)
                                            self.socket.sendMessage(message)   

                                        }
                                    }
                                }
                            }
                        }
                   }
                }
            }
            
            return

            }))


            alert.addAction(UIAlertAction(title: "No thanks", style: .Cancel, handler: { action -> Void in

                
                
            }))
        
            self.presentViewController(alert, animated: true, completion: nil)
                               

        }


    }

    func simpleMessageReceived(message: Motion.Message_)
    {

        switch message.types.hashValue
        {
            case Motion.Message_.ActionType.Engage.hashValue:
                //self.engage(message)
            break
            
            case Motion.Message_.ActionType.ServerInfo.hashValue:
                //self.getImage(message)
            break
        
            default:
                break
        }  

    }

    func checkCategories(sender:UIButton)
    {
        if (sender.tag == 5)
        {

        }        
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.devices.count == 0
        {
            return 0
        } else
        {
            if self.devices[section].joined
            {
                let count = self.devices.count
                print(count)
                return count
            } else 
            {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("cellCamera") as? DeviceTableViewCell
        
        if cell == nil
        {
            print("null")
        }

        if self.devices[indexPath.row].running
        {
           cell!.statusImage.image = UIImage(named: "camerarunning")    
        } else 
        {
            cell!.statusImage.image = UIImage(named: "cameraon")    
        }

        cell!.thumbnailImage.image = self.devices[indexPath.section].cameras[indexPath.row].thumbnail

        let camera = "Camera\(self.devices[indexPath.section].cameras[indexPath.row].cameranumber)"    

        cell!.cameraLabel?.text = camera
        
        cell!.cameraName?.text = self.devices[indexPath.section].cameras[indexPath.row].cameraname

        cell!.textLabel?.text = self.devices[indexPath.row].ipnumber
        
        return cell!

    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 80
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
  
    
    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning() 
    }

}

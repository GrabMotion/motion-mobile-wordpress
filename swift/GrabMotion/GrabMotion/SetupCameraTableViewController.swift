
//  SetupCameraTableViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 3/5/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse

class SetupCameraTableViewController: UITableViewController,
SocketProtocolDelegate 
{

    var devices = [Device]()

    var socket = Socket()

    let defaults = NSUserDefaults.standardUserDefaults()

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var jobView : JobViewController!    

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
        print(self.devices.count)
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

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? 
    {
        
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

        let rdevice = self.devices[indexPath.section]
        
        if !rdevice.joined
        {

            let message = "Would you like to join device \(self.devices[indexPath.section].hostname)?"

            let alert = UIAlertController(title: "Join device", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action -> Void in

                if let profile_stored:Bool = self.defaults.boolForKey("device_stored")
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                    {
                       
                       let raspRel:PFRelation = PFUser.currentUser()!.relationForKey("device") as PFRelation

                        let queryDevice: PFQuery = raspRel.query()

                        queryDevice.findObjectsInBackgroundWithBlock {(deviceobjects:[PFObject]?, error:
                            NSError?) -> Void in                        
                            
                            if error != nil
                            {
                                print("error")
                            } else {
                                
                                if deviceobjects!.count > 0
                                {

                                    if let deviceArray = deviceobjects
                                    {   

                                        deviceArray[0]["ipaddress"]         = rdevice.ipnumber                                        
                                        deviceArray[0]["publicipaddress"]   = rdevice.ippublic
                                        deviceArray[0]["hostname"]          = rdevice.hostname
                                        deviceArray[0]["model"]             = rdevice.model
                                        deviceArray[0]["location"]          = rdevice.location                                        
                                        
                                        deviceArray[0].saveInBackgroundWithBlock
                                        {
                                            (success: Bool , error: NSError?) -> Void in
                                             
                                            if success
                                            {
                                                print("Device Stored.")  

                                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "device_stored")
                                                NSUserDefaults.standardUserDefaults().synchronize()

                                                self.sendClientToRasp()

                                            } else 
                                            {
                                                print("Device Not Stored.") 
                                            }
                                        }
                                    }

                                } else 
                                {

                                   let pdevice = PFObject(className: "Device")

                                   let uuid_raspberry_installation = NSUUID().UUIDString
                                   pdevice.setObject(uuid_raspberry_installation, forKey: "uuid_installation")

                                   pdevice.setObject(rdevice.ipnumber, forKey: "ipaddress")

                                   pdevice.setObject(rdevice.ippublic, forKey: "publicipaddress")

                                   pdevice.setObject(rdevice.hostname, forKey: "hostname")

                                   pdevice.setObject(rdevice.model, forKey: "model")

                                   pdevice.setObject(rdevice.location, forKey: "location")

                                   pdevice.saveInBackgroundWithBlock ({
                                        (success: Bool, error: NSError?) -> Void in

                                        let pfuser  = PFUser.currentUser()
                                    
                                        if pfuser != nil
                                        {

                                            let raspRel:PFRelation = pfuser!.relationForKey("device") as PFRelation
                                            raspRel.addObject(pdevice)

                                            pfuser!.saveInBackgroundWithBlock
                                            {
                                                (success: Bool , error: NSError?) -> Void in
                                                 
                                                if success
                                                {
                                                    print("Device Stored.")  

                                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "device_stored")
                                                    NSUserDefaults.standardUserDefaults().synchronize()

                                                    self.sendClientToRasp()

                                                } else 
                                                {
                                                    print("Device Not Stored.") 
                                                }
                                            }
                                        }
                                    }) 

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

    func sendClientToRasp()
    {

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

                        var _username = quser["username"] as! String
                        var _email = quser["email"] as! String
                        var _first_name = quser["first_name"] as! String
                        var _last_name = quser["last_name"] as! String
                        var _location = quser["location"] as! PFGeoPoint
        
                        let relDevice:PFRelation = quser["device"] as! PFRelation

                        let queryDevice:PFQuery = relDevice.query()

                        queryDevice.findObjectsInBackgroundWithBlock {(deviceobjects:[PFObject]?, error:
                            NSError?) -> Void in
                                                        
                            if error != nil
                            {
                                print("error")
                            } else {
                                
                                if let deviceArray = deviceobjects
                                {
                                    
                                    for qdevice in deviceArray
                                    {
                                        let pfobjectid = quser.objectId
                                        
                                        let uiidinstallation = qdevice["uuid_installation"] as! String

                                        var deviceIp = qdevice["ipaddress"] as! String
                                        
                                        // CLIENT

                                        let clientRelation  = quser["client"] as? PFRelation
                                        
                                        let queryClient = clientRelation!.query()

                                        queryClient.findObjectsInBackgroundWithBlock {(clientobjects:[PFObject]?, error:
                                            NSError?) -> Void in

                                            if error != nil
                                            {
                                                print("error")

                                            } else {
                                            
                                                if let clientArray = clientobjects
                                                {

                                                    print(clientobjects!.count)

                                                    let qclient = clientArray[0] as PFObject

                                                    //for qclient in clientArray
                                                    //{

                                                    let _wp_user                = qclient["wp_user"] as! String
                                                    let _wp_password            = qclient["wp_password"] as! String
                                                    let _wp_server_url          = qclient["wp_server_url"] as! String
                                                    let _wp_userid              = qclient["wp_userid"] as! Int
                                                    let _wp_userid_             = Int32(_wp_userid) 
                                                    let _wp_client_id           = qclient["wp_client_id"] as! Int
                                                    let _wp_client_id_          = Int32(_wp_client_id)
                                                    let _wp_client_mediaid      = qclient["wp_client_media_id"] as! Int
                                                    let _wp_client_mediaid_     = Int32(_wp_client_mediaid)
                                                    let _wp_slug                = qclient["wp_slug"] as! String
                                                    let _wp_link                = qclient["wp_link"] as! String
                                                    let _wp_api_link            = qclient["wp_api_link"] as! String
                                                    let _wp_client_media_id     = qclient["wp_client_media_id"] as! Int
                                                    let _wp_client_media_id_    = String(_wp_client_media_id)
                                                    let _wp_type                = qclient["wp_type"] as! String
                                                    let _wp_modified            = qclient["wp_modified"] as! String
                                                    let _wp_post_parent         = qclient["wp_post_parent"] as! Int
                                                    let _wp_post_parent_        = Int32(_wp_post_parent)
                                                         
                                                    let wpserverurl = (_wp_server_url as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                                                    let wpserverurlbase64  = wpserverurl!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

                                                    print("....................................")
                                                    print( "_email               :\(_email              )")
                                                    print( "_first_name          :\(_first_name         )")
                                                    print( "_last_name           :\(_last_name          )")
                                                    print( "_location            :\(_location           )")
                                                    print("------------------------------------")
                                                    print( "_wp_user             :\(_wp_user            )")
                                                    print( "_wp_password         :\(_wp_password        )")
                                                    print( "_wp_server_url       :\(_wp_server_url      )")
                                                    print( "_wp_userid_          :\(_wp_userid_         )")
                                                    print( "_wp_client_id_       :\(_wp_client_id_      )")
                                                    print( "_wp_client_mediaid_  :\(_wp_client_mediaid_ )")
                                                    print( "_wp_slug             :\(_wp_slug            )")
                                                    print( "_wp_link             :\(_wp_link            )")
                                                    print( "_wp_api_link         :\(_wp_api_link        )")
                                                    print( "_wp_client_media_id_ :\(_wp_client_media_id_)")
                                                    print( "_wp_type             :\(_wp_type            )")
                                                    print( "_wp_modified         :\(_wp_modified        )")
                                                    print( "_wp_post_parent_     :\(_wp_post_parent_    )")
                                                    print("....................................")   
                                                
                                                    let message                 = Motion.Message_.Builder()
                                                    message.types               = Motion.Message_.ActionType.ServerInfo
                                                    message.serverip            = deviceIp                                                    
                                                    message.packagesize         = self.socket.packagesize  
                                                    message.includethubmnails   = false

                                                    let pfuser              = Motion.Message_.MotionUser.Builder()
                                                    pfuser.username         = _username
                                                    pfuser.wpuser           = _wp_user
                                                    pfuser.wppassword       = _wp_password
                                                    pfuser.wpserverurl      = _wp_server_url    
                                                    pfuser.wpclientid       = _wp_client_id_
                                                    pfuser.wpclientmediaid  = _wp_client_mediaid_
                                                    pfuser.wptype           = _wp_type
                                                    
                                                    pfuser.email            = _email
                                                    pfuser.firstname        = _first_name
                                                    pfuser.lastname         = _last_name
                                                    pfuser.location         = "\(_location.latitude), \(_location.longitude)"
                                                    
                                                    pfuser.uiidinstallation = uiidinstallation
                                                    pfuser.clientnumber     = _wp_userid_
                                                    pfuser.pfobjectid       = pfobjectid!

                                                    pfuser.wpslug           = _wp_slug
                                                    pfuser.wplink           = _wp_link
                                                    pfuser.wpapilink        = _wp_api_link
                                                    pfuser.wpfeaturedimage  = _wp_client_media_id_
                                                    pfuser.wpmodified       = _wp_modified
                                                    pfuser.wpparent         = _wp_post_parent_

                                                    do
                                                    {                            
                                                        try message.motionuser += [pfuser.build()]
                                                    } catch
                                                    {
                                                        print(error)
                                                    }


                                                    let error:NSError!

                                                    var data:NSData!
                                                    do
                                                    {
                                                        let m = try message.build()
                                                        data = m.data()

                                                    } catch
                                                    {
                                                        print(error)
                                                    }
                                                    
                                                    if (data != nil)
                                                    {
                                                        print(data.length)
                                                    }

                                                    self.socket.deviceIp = deviceIp
                                                    self.socket.sendMessage(data)
                                                   
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
               }
            }
        }
    }  

    func imageProgress(progress : Int,  total : Int)
    {

    }

    func simpleMessageReceived(message: Motion.Message_)
    {
        switch message.types.hashValue
        {
            
            case Motion.Message_.ActionType.ServerInfoOk.hashValue:
            
                let rdevices:[Motion.Message_.MotionDevice] = message.motiondevice

                var i = 0
                for rdevice:Motion.Message_.MotionDevice in rdevices   
                {

                    if rdevice.serial == devices[i].serial
                    {
                        devices[i].joined = true
                    }
                    i++
                }

                self.reload()
            
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {        

        let jobViewStory = self.storyboard?.instantiateViewControllerWithIdentifier("JobViewController") as! JobViewController
        
        let index = indexPath.section

        print(index)
        
        jobViewStory.device = self.devices[index]

        print(jobViewStory.device.ipnumber)

        let jobViewNav = UINavigationController(rootViewController: jobViewStory)
    
        self.appDelegate.window?.rootViewController = jobViewNav

    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 80
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat 
    {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
        
        if segue.identifier == "SegueJobCreation"
        {
            let nav = segue.destinationViewController as! UINavigationController
            self.jobView = nav.topViewController as! JobViewController      
        }

    }
  
    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning() 
    }

}

//
//  FreePlanViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/21/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse


class FreePlanViewController: UIViewController,
    ServerControllerDelegate {

    @IBOutlet weak var serverUrlTextField: UITextField!
    @IBOutlet weak var serverUser: UITextField!
    @IBOutlet weak var serverPass: UITextField!
    
    var server:ServerController = ServerController()

    let defaults = NSUserDefaults.standardUserDefaults()

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //var email = String()
    //var first_name = String()
    //var last_name = String()

    var mainController:MainViewController?

    var clientThumbnail:UIImage!

    //var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()  

        self.setTextFieldData()
    }

    func setTextFieldData()
    {
         let url = self.server.myWordPressSite

        print(url)

        if self.serverUrlTextField != nil
        {
            self.serverUrlTextField.text = url    
            print("\(self.serverUrlTextField.text)")

            self.serverUser.text = "admin"
            self.serverPass.text = "@TTOZe8xgKtzJc2qLFOM7nUQ"
            
        }   
    }

    @IBAction func continueToSetup(sender: AnyObject)
    {

        let urlText = self.serverUrlTextField.text

        if urlText!.rangeOfString("http://") == nil
        {
            print("http not exists")

            let message = "The url provided is not valid, please enter a valid url."
            let alert = UIAlertController(title: "Url not valid", message: message, preferredStyle: UIAlertControllerStyle.Alert)               
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in

                self.serverUrlTextField.text = ""

            }))

        } else if self.serverUser.text!.isEmpty || self.serverPass.text!.isEmpty
        {

            print("user or pass empty")

            let message = "PLease provide the required user and password field of your server account."
            let alert = UIAlertController(title: "User of passowrd empty", message: message, preferredStyle: UIAlertControllerStyle.Alert)               
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in

                self.serverUser.text = ""
                self.serverPass.text = ""

            }))

        } else 
        {
            
            let server_tasks:Bool = defaults.boolForKey("server_tasks")
            if !server_tasks
            {
                self.server.delegateServer = self

                let usr = self.serverUser.text!
                let pss = self.serverPass.text!

                self.server.setUserCredentials(usr, pss:pss)

                self.server.setProfilePicture(clientThumbnail)

                self.server.createWPUser()
            }
        } 
    }
    
    func errorServerPopOver()
    {
        let message = "There has been a problem while creating the server resources for your account, please verify your installation and try again or else contact support."
        let alertError = UIAlertController(title: "Url not valid", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertError.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in
            
            self.serverUrlTextField.text = ""
            
        }))
        
        alertError.addAction(UIAlertAction(title: "Contact Support", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in

        }))

        let popover = alertError.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        presentViewController(alertError, animated: true, completion: nil)

    }

     @IBAction func guideButton(sender: AnyObject) 
    {
        //self.performSegueWithIdentifier("SegueInstallationGuide", sender: self)      

        /*let ac = UIAlertController(title: "Select Input", message: nil, preferredStyle: .ActionSheet)
       
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        ac.addAction(cancelAction)
        
        ac.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (UIAlertAction) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Gallery", style: .Default, handler: { (UIAlertAction) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }))
       
        
        let popover = ac.popoverPresentationController
        popover?.sourceView = collectionView.cellForItemAtIndexPath(indexPath)
        popover?.sourceRect = (collectionView.cellForItemAtIndexPath(indexPath)?.bounds)!
        popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        presentViewController(ac, animated: true, completion: nil)*/
    }
    
    
    
    

    @IBAction func helpUrlButton(sender: AnyObject)
    {
        //self.performSegueWithIdentifier("SegueServerBase", sender: self)
    }

    @IBAction func helpCredentials(sender: AnyObject)
    {
        
    }
    
    func checkLoginResponse(response:Int, callback:String)
    {
        /*if callback == "users"    
        {
            if response != self.appDelegate.REQUEST_FAILED
            {

                let usr = self.serverUser.text!
                let pss = self.serverPass.text!

                self.server.setUserCredentials(usr, pss:pss)

                self.server.remoteLoginiOS(usr, password: pss, endpoint:"users")


            } else if response == self.appDelegate.LOGGED_IN
            {
                self.errorServerPopOver()

            } else if response == self.appDelegate.REQUEST_FAILED
            {
                self.errorServerPopOver()
            }

        } else if callback == "client"    
        {
            if response != self.appDelegate.REQUEST_FAILED
            {

                let usr = self.serverUser.text!
                let pss = self.serverPass.text!

                self.server.setUserCredentials(usr, pss:pss)

                self.server.remoteLoginiOS(usr, password: pss, endpoint:"users")

            } else if response == self.appDelegate.LOGGED_IN
            {
                self.errorServerPopOver()

            } else if response == self.appDelegate.REQUEST_FAILED
            {
                self.errorServerPopOver()
            }
        }*/

    }

    func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String, type: String)
    {

        /*if type == "users"
        {

            if Motion.Message_.ResponseType.LoginSuccessful.hashValue == reponsetype.hashValue
            {
    
                self.server.createClient()

            } else 
            {
                self.errorServerPopOver()
            }

        else if type == "client"
        {

            if Motion.Message_.ResponseType.LoginSuccessful.hashValue == reponsetype.hashValue
            {
                print("User updated password")
                
                let wp_registered_user:String = self.defaults.stringForKey("wp_username")!
                let wp_registered_pass:String = self.defaults.stringForKey("wp_password")!
                
                self.server.remoteLoginiOS(wp_registered_user, password: wp_registered_pass, endpoint:"client")
            
            } else 
            {
                self.errorServerPopOver()
            }

        }*/
    }


    func registrationCompleted()
    {

        let message = "The profile setup has finished, please setup your devices and start enjoying."
        let alertFinished = UIAlertController(title: "Profile finished", message: message, preferredStyle: UIAlertControllerStyle.Alert)               
        
        alertFinished.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in

            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profile_finished")
            NSUserDefaults.standardUserDefaults().synchronize()

            self.mainController!.selectedIndex = 1

        }))

        let popover = alertFinished.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
    
        presentViewController(alertFinished, animated: true, completion: nil)

    }


    func popover(msg:String)
    {

        let alertMessage = UIAlertController(title: "Message", message: msg, preferredStyle: UIAlertControllerStyle.Alert)               
        
        alertMessage.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in

        }))

        let popover = alertMessage.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
    
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }

    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
        
        if segue.identifier == "SegueSupport"
        {

        } else if segue.identifier == "SegueServerBase"
        {

        } else if segue.identifier == "SegueInstallationGuide"
        {
            
        }
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

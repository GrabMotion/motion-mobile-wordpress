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
    
    var serverTasks:ServerController = ServerController()

    let defaults = NSUserDefaults.standardUserDefaults()

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var email = String()
    var first_name = String()
    var last_name = String()

    var mainController:MainViewController?

    var clientThumbnail:UIImage!

    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()  

        self.setTextFieldData()

    }

    func setTextFieldData()
    {
         let url = self.serverTasks.myWordPressSite

        print(url)

        if self.serverUrlTextField != nil
        {
            self.serverUrlTextField.text = url    
            print("\(self.serverUrlTextField.text)")

            self.serverUser.text = "jose"
            self.serverPass.text = "joselon"

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
                self.serverTasks.delegateServer = self
                self.serverTasks.checkLogin()
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
    
    func checkLoginResponse(response:Int, resutl:String)
    {
        if response != self.appDelegate.REQUEST_FAILED
        {

            let user:PFUser  = PFUser.currentUser()!
            self.userName = "\(user.username!)"

            print(self.userName)

            //let email = "\(user.email)"
            let pass = randomStringWithLength(20)

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
                            self.email = quser["email"] as! String
                            print("email \(self.email)")
                            self.first_name = quser["first_name"] as! String
                            self.last_name = quser["last_name"] as! String

                             print("email \(self.email)")

                            self.serverTasks.createUser(
                                self.serverUser.text!,
                                passServer : self.serverPass.text!,
                                user : self.userName,
                                pass : pass as String,  
                                email : self.email,
                                first_name: self.first_name,
                                last_name: self.last_name)
                        }
                    }
                }
            }

        } else if response == self.appDelegate.REQUEST_FAILED
        {
            self.errorServerPopOver()
        }
    }

    func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String)
    {
        if Motion.Message_.ResponseType.LoginSuccessful.hashValue == reponsetype.hashValue
        {

            self.serverTasks.postClientThumbnail(self.serverUser.text!,
                passServer : self.serverPass.text!,
                name : self.userName,
                image : self.clientThumbnail)
            
        } else 
        {
            self.errorServerPopOver()
        }
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

    /*func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String)
    {

        if Motion.Message_.ResponseType.LoginSuccessful.hashValue == reponsetype.hashValue
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
            
        
        } else 
        {
            self.errorServerPopOver()
        }


    }*/

    func randomStringWithLength (len : Int) -> NSString {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var randomString : NSMutableString = NSMutableString(capacity: len)

        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }

        return randomString
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

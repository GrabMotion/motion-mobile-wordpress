//
//  ProFileViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/31/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils
import SVProgressHUD

class ProFileViewController: UIViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIPopoverPresentationControllerDelegate,
    ServerControllerDelegate
{

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var profileImage: UIImageView!
    
    var imageData = NSData()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var serverUrlTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var geoPoint = PFGeoPoint()
    
    var socialLabel = String()
    var social = String()
    var profileloaded = String()

    var user_social_profile_picture = Bool()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var mainController:MainViewController?

    var serverTasks:ServerController = ServerController()

    var email = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.fetchGeoLocation()
    
        if let loaded = defaults.stringForKey("profile_data_stored")
        {
        
            let user = PFUser.currentUser()
        
            let name =  "\(user!["first_name"]) \(user!["last_name"])"
        
            self.nameLabel.text = name
            
            if let userImageFile = user!["profile_picture"] as? PFFile
            {
                
                userImageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    
                    self.setProfilePicture(UIImage(data:imageData!)!)
                    
                }
            }   
        } 
        


       let profile_finished = defaults.boolForKey("profile_data_stored")
        
        if !profile_finished
        {
            social = defaults.stringForKey("social")!
        
            if social == "facebook"
            {
                socialLabel = "Facebook"
                fetchFacebookProfileData()
            } else if social == "twitter"
            {
                socialLabel = "Twitter"
                getTwitterProfileData()
            } else if social == "email"
            {
                //getParseUserData()
            }
        } else 
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
                            self.email = quser["email"] as! String
                        }
                    }
                }
            }

        }


        self.serverUrlTextField.text = self.serverTasks.myWordPressSite

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
    
    
    @IBAction func helpButton(sender: AnyObject) 
    {
        //self.performSegueWithIdentifier("SegueServerBase", sender: self)
    }

    @IBAction func continueToSetup(sender: AnyObject)
    {

        let urlText = self.serverUrlTextField.text

        var string = "hello Swift"

        if urlText!.rangeOfString("http://") == nil
        {
            print("http not exists")

            let message = "The url provided is not valid, please enter a valid url."
            let alert = UIAlertController(title: "Url not valid", message: message, preferredStyle: UIAlertControllerStyle.Alert)               
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (swiftsUIAlertAction) -> Void in

                self.serverUrlTextField.text = ""

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

    func checkLoginResponse(response:Int, resutl:String)
    {
        if response != self.appDelegate.REQUEST_FAILED
        {

            let user:PFUser  = PFUser.currentUser()!
            let userName = "\(user.username)"
            //let email = "\(user.email)"
            let pass = randomStringWithLength(20)

            self.serverTasks.createUser(userName, email: self.email, pass: pass as String)
 
        } else if response == self.appDelegate.REQUEST_FAILED
        {
            self.errorServerPopOver()
        }
    }

    func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String)
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

    func fetchGeoLocation()
    {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if (geoPoint != nil)
            {
                print("\(geoPoint)")
                
                self.geoPoint = geoPoint!
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(geoPoint!.latitude, geoPoint!.longitude)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func getInitialPicture()
    {
        
        let ac = UIAlertController(title: "Pleases provide a picture of yourself in order to identify you on the system.", message: nil, preferredStyle: .ActionSheet)
        
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
        
        if social == "facebook" || social == "twitter"
        {
            let socialPic = "Use \(socialLabel) profile picture"
            ac.addAction(UIAlertAction(title: socialPic, style: .Default, handler: { (UIAlertAction) -> Void in
                self.user_social_profile_picture = true
            }))
        }
        
        let popover = ac.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        presentViewController(ac, animated: true, completion: nil)
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            let user = PFUser.currentUser()
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.05)
            let imageFile = PFFile(data:imageData!)
            
            user!.setObject(imageFile!, forKey: "profile_picture")
            
            user!.setObject(self.geoPoint, forKey: "location")
            
            user!.saveInBackgroundWithBlock
            {
                (success: Bool, error: NSError?) -> Void in
                    if (success)
                    {
                        print("location stored")
                    
                        NSUserDefaults.standardUserDefaults().setObject("true", forKey: "profile_data_stored")
                        NSUserDefaults.standardUserDefaults().synchronize()

                        self.setProfilePicture(pickedImage)

                        // self.getInitialPicture()
                    
                    } else {
                        print("location cannot be stored")
                    }
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchFacebookProfileData()
    {
        
        let facebookSpinner = SpinnerViewController(message: "Loading Twitter information please wait...")
        presentViewController(facebookSpinner, animated: true, completion: nil)

        
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
                print("\(error.localizedDescription)")
                return
            }
            
            if(result != nil)
            {
                
                let userId:String = result["id"] as! String
                let userFirstName:String! = result["first_name"] as? String
                let userLastName:String! = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                self.email = userEmail!
                
                let fullname = "\(userFirstName) \(userLastName)"

                self.nameLabel.text = fullname

                print("\(userEmail)")
                
                let fbUser:PFUser = PFUser.currentUser()!
                
                // Save first name
                if(userFirstName != nil)
                {
                    fbUser.setObject(userFirstName!, forKey: "first_name")
                }
                
                //Save last name
                if(userLastName != nil)
                {
                    fbUser.setObject(userLastName!, forKey: "last_name")
                }
                
                // Save email address
                if(userEmail != nil)
                {
                    fbUser.setObject(userEmail!, forKey: "email")
                }
                
                // Save location
                if(userEmail != nil)
                {
                    fbUser.setObject(self.geoPoint, forKey: "location")
                }
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                {
                        
                        // Get Facebook profile picture
                        let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                        
                        let profilePictureUrl = NSURL(string: userProfile)
                        
                        let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                    
                        let profilePicture: UIImage! = UIImage(data:profilePictureData!)
                        
                        if(profilePictureData != nil)
                        {
                            self.setProfilePicture(profilePicture)
                            let profileFileObject = PFFile(data:profilePictureData!)
                            fbUser.setObject(profileFileObject!, forKey: "profile_picture")
                        }
                    
                        fbUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            
                            if(success)
                            {
                                print("User details are now updated")
                            
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profile_data_stored")
                                NSUserDefaults.standardUserDefaults().synchronize()

                                facebookSpinner.dismissViewControllerAnimated(true, completion: nil)
                                self.getInitialPicture()
                            }
                            
                        })
                }
            }
            
        }
    }
    
 

     func getTwitterProfileData()
    {
        
        let twitterSpinner = SpinnerViewController(message: "Loading Twitter information please wait...")
        presentViewController(twitterSpinner, animated: true, completion: nil)
    

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI

        
                if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()!) {
                
                    let myUser:PFUser = PFUser.currentUser()!
                    
                    let screenName = PFTwitterUtils.twitter()?.screenName!
                    let requestString = NSURL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=" + screenName! + "&include_email=1")
                    
                    let request = NSMutableURLRequest(URL: requestString!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
                    
                    PFTwitterUtils.twitter()?.signRequest(request)
                    let session = NSURLSession.sharedSession()
                    
                    session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                        
                        print(data)
                        print(response)
                        //print(error)
                        
                        if error == nil
                        {
                            var result: AnyObject?
                            do
                            {
                                
                                result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                                
                            } catch let error2 as NSError? {
                                
                                print("error 2 \(error2)")
                            }
                            
                            let names: String! = result?.objectForKey("name") as! String
                            let separatedNames: [String] = names.componentsSeparatedByString(" ")
                        
                            let userFirstName:String! = separatedNames[0] as String
                            let userLastName:String! = separatedNames[1] as String
                            
                            let fullname = "\(userFirstName) \(userLastName)"

                            self.nameLabel.text = "\(userFirstName) \(userLastName)"

                            //let email: String! = result?.objectForKey("mail") as! String
                            
                            
                            // Save first name
                            if(userFirstName != nil)
                            {
                                myUser.setObject(userFirstName!, forKey: "first_name")
                                
                            }
                            
                            //Save last name
                            if(userLastName != nil)
                            {
                                myUser.setObject(userLastName!, forKey: "last_name")
                            }
                            
                            // Save email address
                            //if(email != nil)
                            //{
                            //    myUser.setObject(email!, forKey: "email")
                            //}
                            
                            // http://stackoverflow.com/questions/22627083/can-we-get-email-id-from-twitter-oauth-api
                            
                            
                            let urlString = result?.objectForKey("profile_image_url_https") as! String
                            
                            let hiResUrlString = urlString.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            
                            print(hiResUrlString)
                            
                            let profilePictureUrl = NSURL(string: hiResUrlString)
                            
                            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                            
                            if(profilePictureData != nil)
                            {
                                let profileFileObject = PFFile(data:profilePictureData!)
                                myUser.setObject(profileFileObject!, forKey: "profile_picture")
                            }
                            
                            myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                                
                                if(success)
                                {
                                    print("User details are now updated")
                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profile_data_stored")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                    self.getInitialPicture()
                                }
                                
                            })
                            
                    
                        }
                        
                    }).resume()
                }
            }
        }
    }
    
    func setProfilePicture(image:UIImage)
    {
            
        self.profileImage.image = image
        
        self.profileImage.contentMode = UIViewContentMode.ScaleToFill
            
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2

        self.profileImage.clipsToBounds = true

        let white = UIColor.whiteColor().CGColor

        profileImage.layer.borderColor = white
        profileImage.layer.borderWidth = 3

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}

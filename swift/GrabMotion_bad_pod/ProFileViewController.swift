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
import FBSDKLoginKit
import SVProgressHUD
 
class ProFileViewController: UIViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIPopoverPresentationControllerDelegate,
    CLLocationManagerDelegate
{

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var profileImage: UIImageView!
    
    var imageData = NSData()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!

    let imagePicker = UIImagePickerController()
    
    var socialLabel = String()
    var social = String()
    var profileloaded = String()

    var user_social_profile_picture = Bool()
    
    let defaults = NSUserDefaults.standardUserDefaults()

    var geoPoint = PFGeoPoint()
    
    //Set to FreePlanViewController
    var email = String()
    var mainController:MainViewController?

    @IBOutlet weak var freeContainer: UIView!
    @IBOutlet weak var paidContainer: UIView!

    @IBOutlet weak var scrollView: UIScrollView!

    var clientThumbnail:UIImage!

    var freeViewController:FreePlanViewController!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 800)

        self.paidContainer.alpha = 0
        self.freeContainer.alpha = 1

        self.mapView.addAnnotation(self.appDelegate.annotation)

    
        if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()) || (FBSDKAccessToken.currentAccessToken() != nil)
        {
    
            if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()) // || (FBSDKAccessToken.currentAccessToken() != nil)
            {
                
                PFTwitterUtils.logInWithBlock
                    {
                        (user:PFUser?, error:NSError?) -> Void in
                        
                        if (user==nil)
                        {
                            print(user)
                            print("Uh oh. The user cancelled the Twitter login.")
                            return
                            
                        } else if ((user?.isNew) != nil)
                        {
                            print("User signed up and logged in with Twitter!")
                            
                            print(user)
                            
                            print("Current user token=\(PFTwitterUtils.twitter()!.authToken)")
                            
                            print("Current user id \(PFTwitterUtils.twitter()!.screenName)")
                            
                            self.loadProfileData()
                                            
                        }
                }
                
                
            } else if let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken()
            {
                
                PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: {
                    (user: PFUser?, error: NSError?) -> Void in
                    
                    if user != nil
                    {
                        print("User logged in through Facebook!")
                        
                        print(user)
                        
                        print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
                        
                        print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
                        
                        self.loadProfileData()                       
                    } else
                    {
                        print("Uh oh. There was an error logging in.")
                    }
                })
            }
        }

    }

    func loadProfileData()
    {
        SVProgressHUD.show()
        self.view.hidden = true

        self.appDelegate.setGeoLocation()

        let social_data_stored = self.defaults.boolForKey("social_data_stored")
        if !social_data_stored
        {   
            self.getSocialProfileData()
        } else 
        {
            self.getUserEmail()
        }
    }
    

    func getSocialProfileData()
    {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) 
        {

            self.social = self.defaults.stringForKey("social")!
        
            if self.social == "facebook"
            {
                self.socialLabel = "Facebook"
                self.fetchFacebookProfileData()
            } else if self.social == "twitter"
            {
                self.socialLabel = "Twitter"
                self.getTwitterProfileData()
            } else if self.social == "email"
            {
                //getParseUserData()
            }
        }
    }

    func fetchFacebookProfileData()
    {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            
            dispatch_async(dispatch_get_main_queue()) {

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
                        let userFirstName:String? = result["first_name"] as? String
                        let userLastName:String? = result["last_name"] as? String
                        let userEmail:String? = result["email"] as? String
                        
                        print("\(userEmail)")
                        
                        let myUser:PFUser = PFUser.currentUser()!
                        
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
                        if(userEmail != nil)
                        {
                            myUser.setObject(userEmail!, forKey: "email")
                        }
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                        {
                                
                                // Get Facebook profile picture
                                let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                                
                                let profilePictureUrl = NSURL(string: userProfile)
                                
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

                                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "social_data_stored")
                                        NSUserDefaults.standardUserDefaults().synchronize()

                                        self.getUserEmail()
                                        
                                    }
                                    
                                })
                        }
                        
                    }
                    
                }
            }
        }
    }

    func getTwitterProfileData()
    {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) 
        {
            // do some task
            
            dispatch_async(dispatch_get_main_queue()) 
            {
                       
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
                                    
                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "social_data_stored")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                
                                    self.getUserEmail()
                                }
                                
                            })
                            
                        }
                        
                    }).resume()
                }
            }
        }
    }

    func getUserEmail()
    {

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) 
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

                            self.getProfileImageAndName()

                        }
                    }
                }
            }
        }
    }

    func getProfileImageAndName()
    {

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) 
        {

            let user = PFUser.currentUser()
        
            let name =  "\(user!["first_name"]) \(user!["last_name"])"
        
            self.nameLabel.text = name
            
            if let userImageFile = user!["profile_picture"] as? PFFile
            {
                
                userImageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    
                    self.setProfilePicture(UIImage(data:imageData!)!)

                    SVProgressHUD.dismiss()

                    self.view.hidden = false

                    let social_data_stored = self.defaults.boolForKey("profile_picture_updated")
                    if !social_data_stored
                    {
                        self.getInitialPicture()
                    }
                }
            }   
        }
    }
        
    func getInitialPicture()
    {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) 
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
            
            if self.social == "facebook" || self.social == "twitter"
            {
                let socialPic = "Use \(self.socialLabel) profile picture"
                ac.addAction(UIAlertAction(title: socialPic, style: .Default, handler: { (UIAlertAction) -> Void in
                    
                    self.user_social_profile_picture = true

                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profile_picture_updated")
                    NSUserDefaults.standardUserDefaults().synchronize()

                }))
            }
            
            let popover = ac.popoverPresentationController
            popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
            
            self.presentViewController(ac, animated: true, completion: nil)

        }
    
    }

    

    @IBAction func showComponent(sender: AnyObject)
    {
        if sender.selectedSegmentIndex == 0
        {
        
            UIView.animateWithDuration(0.5, animations: {
                self.freeContainer.alpha = 1
                self.paidContainer.alpha = 0
            })
        
        } else if sender.selectedSegmentIndex == 1
        {
            UIView.animateWithDuration(0.5, animations: {
                self.freeContainer.alpha = 0
                self.paidContainer.alpha = 1
            })
        }
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            let user = PFUser.currentUser()
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.05)
            let imageFile = PFFile(data:imageData!)
            
            user!.setObject(imageFile!, forKey: "profile_picture")
            
            user!.saveInBackgroundWithBlock
            {
                (success: Bool, error: NSError?) -> Void in
                    if (success)
                    {
                                         
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "profile_picture_updated")
                        NSUserDefaults.standardUserDefaults().synchronize()

                        self.setProfilePicture(pickedImage)
                        
                    } else {
                        print("image cannot be stored")
                    }
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueFreeVersion"
        {    

            self.freeViewController = segue.destinationViewController as! FreePlanViewController

            //self.freeViewController.email = self.email
            
            self.freeViewController.mainController = mainController

            self.freeViewController.clientThumbnail = self.clientThumbnail

            self.freeViewController.setTextFieldData()

        } else if segue.identifier == "SeguePaidVersion"
        {

        }
    }

    func setProfilePicture(image:UIImage)
    {

        self.clientThumbnail = image
            
        self.profileImage.image = image
        
        self.profileImage.contentMode = UIViewContentMode.ScaleToFill
            
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2

        self.profileImage.clipsToBounds = true

        let white = UIColor.whiteColor().CGColor

        profileImage.layer.borderColor = white
        profileImage.layer.borderWidth = 3

        self.freeViewController.clientThumbnail = image

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

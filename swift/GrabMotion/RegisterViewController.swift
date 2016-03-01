//
//  RegisterViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/30/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils
import FBSDKLoginKit
import FBSDKCoreKit
import CoreLocation
import Foundation


class RegisterViewController: UIViewController, 
UITextFieldDelegate,
CLLocationManagerDelegate
{
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var userName: UITextField!
        
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var FacebookLoginButton: UIView!
    
    @IBOutlet weak var TwitterLoginButton: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

     var locationManager: CLLocationManager!
    
    var geopoint = PFGeoPoint()
    
    var TYPE_SIGNUP     = 0
    var TYPE_FACEBOOK   = 1
    var TYPE_TWITTER    = 2
    
    @IBOutlet weak var facebook: UIView!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        spinner.hidden = true

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        let FBtapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("facebookSignIn:"))
        FacebookLoginButton.userInteractionEnabled = true
        FacebookLoginButton.addGestureRecognizer(FBtapGestureRecognizer)
        
        self.TwitterLoginButton.layer.cornerRadius = 5
        
        let TWtapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("twitterSignIn:"))
        TwitterLoginButton.userInteractionEnabled = true
        TwitterLoginButton.addGestureRecognizer(TWtapGestureRecognizer)

        firstName.clearButtonMode = .WhileEditing
        lastName.clearButtonMode = .WhileEditing
        userName.clearButtonMode = .WhileEditing
        email.clearButtonMode = .WhileEditing
        password.clearButtonMode = .WhileEditing
        
        /*PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if (geoPoint != nil)
            {
                self.geopoint = geoPoint!
            }
        }*/

        self.authorizeLocation()
        
        setInputTexts()

    
    }

    func authorizeLocation()
    {
        //AUTHORIZE LOCATION
        if CLLocationManager.locationServicesEnabled()
        {
            NSUserDefaults.standardUserDefaults().setObject("requested", forKey: "location")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if locationManager != nil
            {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
    
        if (status == CLAuthorizationStatus.AuthorizedAlways)
        {
            
            self.locationManager.startUpdatingLocation()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "location_authorized")
            NSUserDefaults.standardUserDefaults().synchronize()

            //Start spinner
            //SVProgressHUD.show()    
            //self.getSocialProfileData()

            //Concatenated Below

            //self.getUserEmail()
            //self.getProfileData()
            //self.setGeoLocation()
            //self.getInitialPicture()

        
        } else if (status == CLAuthorizationStatus.Denied)
        {
            //SALIR
        }
    
    }

    func locationManager(manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
    {
        let currentLocation = locations.last! as CLLocation
        print(currentLocation)
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError)
    {
        print(error)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == firstName
        {
           lastName.becomeFirstResponder()
        } else if textField == lastName
        {
            userName.becomeFirstResponder()
        } else if textField == userName
        {
            email.becomeFirstResponder()
        } else if textField == email
        {
           password.becomeFirstResponder()
        } else if textField == password
        {
            password.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == userName
        {
            userName.text = "\(firstName.text!)\(lastName.text!)"
        }
    }
    
    @IBAction func sigUp(sender: AnyObject)
    {
        agreeWithTermsAndConditions(TYPE_SIGNUP)
    }
        
    func facebookSignIn(sender:UITapGestureRecognizer)
    {
        agreeWithTermsAndConditions(TYPE_FACEBOOK)
    }
    
    func twitterSignIn(sender:UITapGestureRecognizer)
    {
        agreeWithTermsAndConditions(TYPE_TWITTER)
    }
    
    func agreeWithTermsAndConditions( type : Int )
    {
        
        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp(type)})
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func processSignUp(type:Int)
    {
        switch type
        {
            case TYPE_SIGNUP:
                mailSignInAgreed()
            break
            
            
            case TYPE_FACEBOOK:
                facebookSignInAgreed()
            break
            
            case TYPE_TWITTER:
                twitterSignInAgreed()
            break
            
            default :
            break
        }
        
    }

    func mailSignInAgreed()
    {
        let first_name = firstName.text
        let last_name = lastName.text
        let user_name = userName.text
        var user_email = email.text
        let user_password = userName.text
        
        // Ensure username is lowercase
        user_email = user_email!.lowercaseString
        
        // Start activity indicator
        spinner.hidden = false
        spinner.startAnimating()
        
        // Create the user
        let user = PFUser()
        user.username = user_name
        user.password = user_password
        user.email = user_email
        
        user.setObject(first_name!, forKey: "first_name")
        user.setObject(last_name!, forKey: "last_name")
        user.setObject(self.geopoint, forKey: "location")
        
        user.signUpInBackgroundWithBlock {
            
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue())
                {
                    
                    NSUserDefaults.standardUserDefaults().setObject("email", forKey: "social")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "registered")
                    NSUserDefaults.standardUserDefaults().synchronize()

                    self.appDelegate.setGeoLocation()
                    
                    self.loadMain()
                }
                
            } else {
                
                self.spinner.stopAnimating()
                
                if let message: AnyObject = error!.userInfo["error"]
                {
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Login error", message: "\(message)", preferredStyle: .Alert)
                    
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                    {
                        UIAlertAction in
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    
                }
            }
        }
    }
    
    func clearInputTexts()
    {
        firstName.text = ""
        lastName.text = ""
        userName.text = ""
        email.text = ""
        password.text = ""
        userName.becomeFirstResponder()
    }
    
    func setInputTexts()
    {
        firstName.text = "Jose"
        lastName.text = "Vigil"
        userName.text = "JoseVigil"
        email.text = "josemanuelvigil@gmail.com"
        password.text = "jose"
    }
    
    func facebookSignInAgreed()
    {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
            
            if(error != nil)
            {
                //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
                return
            }
            
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                print(user)
                
                print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
                
                print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
                
                NSUserDefaults.standardUserDefaults().setObject("facebook", forKey: "social")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "registered")
                NSUserDefaults.standardUserDefaults().synchronize()

                self.appDelegate.setGeoLocation()
            
                self.loadMain()
                
            }
            
        })
    }

    func twitterSignInAgreed()
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
                    
                    NSUserDefaults.standardUserDefaults().setObject("twitter", forKey: "social")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "registered")
                    NSUserDefaults.standardUserDefaults().synchronize()

                    self.appDelegate.setGeoLocation()
                    
                    self.loadMain()
                    
                } else
                {
                    print("User logged in with Twitter!")
                }
        }
        
    }

    func loadMain()
    {
        
        let mainView = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        
        let protectedPageNav = UINavigationController(rootViewController: mainView)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = protectedPageNav
        
    }
    
}

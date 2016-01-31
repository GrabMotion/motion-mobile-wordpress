//
//  RegisterViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/30/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4
import ParseTwitterUtils
import FBSDKLoginKit
import FBSDKCoreKit
import CoreLocation
import Foundation


class RegisterViewController: UIViewController
{

    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var twitter: UIView!
    
    @IBOutlet weak var FacebookLoginButton: UIView!
    
    @IBOutlet weak var TwitterLoginButton: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var TYPE_SIGNUP     = 0
    var TYPE_FACEBOOK   = 1
    var TYPE_TWITTER    = 2
    
    @IBOutlet weak var facebook: UIView!
    
    @IBAction func sigUp(sender: AnyObject)
    {
        agreeWithTermsAndConditions(TYPE_SIGNUP)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        spinner.hidden = true
        
        let FBtapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("facebookSignIn:"))
        FacebookLoginButton.userInteractionEnabled = true
        FacebookLoginButton.addGestureRecognizer(FBtapGestureRecognizer)
        
        self.TwitterLoginButton.layer.cornerRadius = 5
        
        let TWtapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("twitterSignIn:"))
        TwitterLoginButton.userInteractionEnabled = true
        TwitterLoginButton.addGestureRecognizer(TWtapGestureRecognizer)

        
    }
    
    func agreeWithTermsAndConditions( type : Int)
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
    
    func processSignUp(type:Int) {
        
        var userEmailAddress = email.text
        var userPassword = password.text
        var userName = username.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress!.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        spinner.hidden = false
        spinner.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
                
            } else {
                
                self.spinner.stopAnimating()
                
                if let message: AnyObject = error!.userInfo["error"]
                {
                    // Create the alert controller
                    var alertController = UIAlertController(title: "Login error", message: "\(message)", preferredStyle: .Alert)
                    
                    // Create the actions
                    var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
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
    
    
    func facebookSignIn(sender:UITapGestureRecognizer)
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
                
                self.launchNewItem()
                
            }
            
        })
    }
    
    func twitterSignIn(sender:UITapGestureRecognizer)
    {
        PFTwitterUtils.logInWithBlock {
            (user:PFUser?, error:NSError?) -> Void in
            
            if error != nil
            {
                self.processTwitterUser()
            }
        }
        
    }
    
    func processTwitterUser()
    {
        
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Loading"
        spiningActivity.detailsLabelText = "Please wait"
        
        let pfTwitter = PFTwitterUtils.twitter()
        
        let twitterUsername = pfTwitter?.screenName
        
        var userDetailsUrls = String()
        userDetailsUrls = "https://api.twitter.com/1.1/users/show.json?screen_name="
        userDetailsUrls = userDetailsUrls + twitterUsername!
        
        let myUrl = NSURL(string: userDetailsUrls);
        let request = NSMutableURLRequest(URL: myUrl!);
        request.HTTPMethod = "GET";
        
        pfTwitter?.signRequest(request);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                
                if error != nil
                {
                    spiningActivity.hide(true)
                    
                    NSUserDefaults.standardUserDefaults().setObject("twitter", forKey: "social")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    PFUser.logOut()
                    
                    return
                }
                
                do
                {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    
                    let parseJSON = NSDictionary()
                    if parseJSON == json
                    {
                        // Extract Profile Image
                        if let profileImageUrl = parseJSON["profile"] as? String
                        {
                            let profilePictureUrl = NSURL(string: profileImageUrl)
                            
                            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                            
                            // Prepare PFUser object
                            if (profilePictureData != nil)
                            {
                                let profileFileObject = PFFile(data: profilePictureData!)
                                PFUser.currentUser()?.setObject(profileFileObject!, forKey: "profile_picture")
                            }
                            
                            PFUser.currentUser()?.username = twitterUsername
                            PFUser.currentUser()?.setObject(twitterUsername!, forKey: "first_name")
                            PFUser.currentUser()?.setObject(" ", forKey: "last_name")
                            
                            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                                
                                if (error != nil)
                                {
                                    spiningActivity.hide(true)
                                    
                                    //Display error message
                                    let userMessage = error!.localizedDescription
                                    let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                                    
                                    myAlert.addAction(okAction)
                                    
                                    self.presentViewController(myAlert, animated: true, completion: nil)
                                    
                                    PFUser.logOut()
                                    
                                    return
                                }
                                
                                spiningActivity.hide(true)
                                
                                NSUserDefaults.standardUserDefaults().setObject(twitterUsername, forKey: "user_name")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                                dispatch_async(dispatch_get_main_queue())
                                    {
                                        self.checkInitItem()
                                }
                            })
                            
                        }
                        
                    }
                    
                } catch {
                    print(error)
                }
        }
    }

    
}

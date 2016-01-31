//
//  SignUpViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/29/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //@IBOutlet weak var message: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func signIn(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    
        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress!.lowercaseString
        
        let userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(userEmailAddress!, password:userPassword!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil
            {
                
                dispatch_async(dispatch_get_main_queue())
                {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
                
            } else {
                
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo["error"] {
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Login error", message: "\(message)", preferredStyle: .Alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        let imageViewMail = UIImageView()
        let imagem = UIImage(named: "mail.png")
        imageViewMail.image = imagem
        emailAddress.leftViewMode = UITextFieldViewMode.Always
        emailAddress.leftView = imageViewMail
        
        let imageViewPass = UIImageView()
        let imagep = UIImage(named: "pass.png")
        imageViewPass.image = imagep
        password.leftViewMode = UITextFieldViewMode.Always
        password.leftView = imageViewPass
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUp(sender: AnyObject)
    {
     self.performSegueWithIdentifier("SegueRegister", sender: self)
            
    }
    


}

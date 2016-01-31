		//
//  ViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/22/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Alamofire


class LoginViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate
{
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()

    var serverrunning = Bool()
    
    var canStartPinging = false

    @IBOutlet weak var serverTextView: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var buttonGuide: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    
        spinner.hidden = true
        
        if (PFUser.currentUser() == nil)
        {
            
            self.logInViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .DismissButton]
            
            self.logInViewController.delegate = self
            
            let logoView = UIImageView(image: UIImage(named:"grabmotion_logo.png"))
            
            self.logInViewController.logInView!.logo  = logoView

            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            
            self.presentViewController(self.logInViewController, animated: true, completion: nil)
            
                        
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let server = defaults.stringForKey("sever")
        {
            print(server)
            if server == "checked"
            {
                self.performSegueWithIdentifier("SegueDevices", sender: self)
            }
        }
        
        self.serverTextView.text = "http://192.168.0.4/digimotion"
        
    }
    
    
    @IBAction func setServerUrl(sender: AnyObject) {
    }
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape")
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
        }
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func setCustomUrlServer(sender: AnyObject)
    {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueDevices"
        {
            let device = segue.destinationViewController as! DeviceViewController
            
            device.serverUrl = self.serverTextView.text!
            
        }
    }
    

    @IBAction func continueButton(sender: AnyObject)
    {
        
        let url = "\(self.serverTextView.text!)/wp-json"
        
        spinner.hidden = false
        spinner.startAnimating()
        
        Alamofire.request(.GET, url)
            .validate()
            .responseJSON { response in
            
            switch response.result
            {
                case .Success:
                    print("Validation Successful")
            
                    NSUserDefaults.standardUserDefaults().setObject("checked", forKey: "server")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    NSUserDefaults.standardUserDefaults().setObject(url, forKey: "serverurl")
                    NSUserDefaults.standardUserDefaults().synchronize()
            
                    self.performSegueWithIdentifier("SegueDevices", sender: self)
            
                    break
                case .Failure(let error):
                    print(error)
            
                    self.spinner.stopAnimating()
                    self.spinner.hidden = false
            
                    let message = "No valid server found on the given url. Pleasee check the installation guide and try again."
                    
                    let alert = UIAlertController(title: "Server not found", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.spinner.hidden = false
                    
                    
                    
                    break
            }
            
            
        }
        
        
        /*Alamofire.request(.GET, url)
            .responseJSON { response in
            
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
               print(response.response)
                
                if response.result
            
            if let JSON = response.result.value
            {
                print("JSON: \(JSON)")
            }
        }*/
        
    }
    
    
}


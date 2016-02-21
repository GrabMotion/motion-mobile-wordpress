//
//  ServerController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/15/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import Parse
import Foundation
import Alamofire
import SwiftyJSON
import ProtocolBuffers

protocol ServerControllerDelegate
{
	func checkLoginResponse(response:Int, resutl:String) 
	func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String)
}

class ServerController 
{

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	var delegateServer:ServerControllerDelegate! = nil

	var myWordPressSite:String = "http://192.168.0.3/grabmotion/wp-json/wp/v2/"
    
    lazy var json : JSON = JSON.null

	 init() 
	 {
	 		
	 }

	func checkLogin()
    {

        dispatch_async(dispatch_get_main_queue()) 
        {

            Alamofire.request(.POST, self.myWordPressSite, parameters: ["check_login": 1])
                .responseJSON { response in
                    
                //Check if response is valid and not empty
                guard let data = response.result.value else
                {
                    //self.loginMessage.text = "Request failed"

                    print("Request failed \(response.result.value)")
                    
                    if (self.delegateServer != nil)
                    {
                        self.delegateServer.checkLoginResponse(self.appDelegate.REQUEST_FAILED, resutl: "Request failed")
                    }

                    return
                }
                
                //Convert data response to json object
                self.json = JSON(data)
                
                //Check if logged in
                guard self.json["logged_in"] != 0 else
                {
                    print("You are not logged in.")
					self.delegateServer.checkLoginResponse(self.appDelegate.NOT_LOGGED_IN, resutl: "You are not logged in.")
                    return
                }
                
                //If logged in, return welcome message
                guard let name = self.json["data"]["display_name"].string else {
                    return
                }

                self.delegateServer.checkLoginResponse(self.appDelegate.LOGGED_IN, resutl: self.json["data"]["display_name"].string!)
                
                print("name: \(name)")
                
            
            }
        }
    }

    func welcomeMessage(name:String)
    {

    }


    func createUser(user:String, email:String, pass:String)
    {
        
        print ("pass: \(pass)")

        let parameters = [
            "username": "\(user)",
            "email": "\(email)",
            "password": "\(pass)"
        ]

        print("myWordPressSite: \(self.myWordPressSite)")

        var usersWordpress:String = "\(self.myWordPressSite)users"
        
        print("usersWordpress: \(usersWordpress)")

        //let credential = NSURLCredential(user: user, password: password, persistence: .ForSession)

        let user = "jose"
        let password = "joselon"

        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])

        let headers = ["Authorization": "Basic \(base64Credentials)"]

        Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
            .responseJSON { response in

             if let JSON = response.result.value 
             {
                print("JSON: \(JSON)")

                dispatch_async(dispatch_get_main_queue()) 
                {   
                    self.remoteLogin(user, password: pass as String)
                }
                   
                let user:PFUser  = PFUser.currentUser()!
                user.setObject("wp_password", forKey: pass as String)
                
                user.saveInBackgroundWithBlock
                {
                    (success: Bool , error: NSError?) -> Void in
                    
                    if success
                    {
                       print("User updated password")
                    }
                }
            }
        }
    }

    func remoteLogin(user: String, password: String)
    {
        
        Alamofire.request(.POST, self.myWordPressSite, parameters: [
            "check_login": 2,
            "ios_userlogin":user,
            "ios_userpassword":password
            ]).responseJSON { response in
                
                //Check if response is valid and not empty
                guard let data = response.result.value else
                {
                    //self.loginAlert("Login Failed")
                    self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.LoginSuccessful, resutl: "Login Failed")
                    return
                }
                
                //Convert data response to json object
                self.json = JSON(data)
                
                //Check for serverside login errors
                guard self.json["error"] == nil else{
                    
                    switch(self.json["error"])
                    {
                    case 1:
                        //self.loginAlert("Invalid Username")
                        self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.ErrorInvalidUsername, resutl: "Invalid Username")

                    case 2:
                        //self.loginAlert("Invalid Password")
                        self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.ErrorInvalidPassword, resutl: "Invalid Password")
                    default:
                        //self.loginAlert("Login Failure")
                        self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.LoginFailed, resutl: "Login Failure")
                    }
                    
                    return
                }
                
             
                let name = self.json["data"]["display_name"].string    
                self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.LoginSuccessful, resutl: name!)
           
        }
    }

    
    /*func loginAlert(alertMessage: String)
    {
        let loginAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        loginAlert.addAction(okAction)
        
        self.presentViewController(loginAlert, animated: true, completion: nil)
    }*/

}
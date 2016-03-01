//
//  ServerController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/15/16.
//  Copyright ÂŠ 2016 GrabMotion Computer Vision. All rights reserved.
//
  
import Parse
import Foundation
import Alamofire
import SwiftyJSON
import ProtocolBuffers
  
protocol ServerControllerDelegate
{
    func checkLoginResponse(response:Int, callback:String) 
    func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String, type:String)
    func registrationCompleted()
    func popover(msg:String)
}
  
class ServerController 
{
  
    var userServer = String()
    var passServer = String()
    var passWord = String()
    var userName = String()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  
    var delegateServer:ServerControllerDelegate! = nil
  
    var myWordPressSite:String = "http://192.168.0.3/grabmotion/wp-json/wp/v2/"

    let defaults = NSUserDefaults.standardUserDefaults()
     
    lazy var json : JSON = JSON.null

  
    init() 
    {
    }
  
    func welcomeMessage(name:String)
    {
        
    }
  
    func setUserCredentials(usr:String, pss:String)
    {
        self.userServer = usr
        self.passServer = pss
    }

    func checkLoginiOS(endpoint:String)
    {
   
        dispatch_async(dispatch_get_main_queue()) 
        {
   
            let url = "\(self.myWordPressSite)\(endpoint)"

            Alamofire.request(.POST, url, parameters: ["check_login": 1])
                .responseJSON { response in
                      
                //Check if response is valid and not empty
                guard let data = response.result.value else
                {
                    //self.loginMessage.text = "Request failed"
   
                    print("Request failed \(response.result.value)")
                      
                    if (self.delegateServer != nil)
                    {
                        self.delegateServer.checkLoginResponse(self.appDelegate.REQUEST_FAILED, callback: endpoint)
                    }
   
                    return
                }
                  
                //Convert data response to json object
                //Convert data response to json object
                self.json = JSON(data)
                  
                //Check if logged in
                guard self.json["logged_in"] != 0 else
                {
                    print("You are not logged in.")
                    self.delegateServer.checkLoginResponse(self.appDelegate.NOT_LOGGED_IN, callback: endpoint)
                    return
                }
                  
                //If logged in, return welcome message
                guard let name = self.json["data"]["user_login"].string else {
                    return
                }
   
                print("name: \(name)")

                self.delegateServer.checkLoginResponse(self.appDelegate.LOGGED_IN, callback: endpoint)

                if name == self.userServer
                {
                    self.createWPUser()
                    
                } else if endpoint == "client"
                {
                    self.createWPClient()
                }

                  
            }
        }
    }


    func remoteLoginiOS(user: String, password: String, endpoint:String)
    {
         
        dispatch_async(dispatch_get_main_queue()) 
        {

            let url = "\(self.myWordPressSite)\(endpoint)"

            print(endpoint)

            Alamofire.request(.POST, url, parameters: [
                "check_login": 2,
                "ios_userlogin":user,
                "ios_userpassword":password
                ])
                .responseJSON { response in
                     
                    //Check if response is valid and not empty
                    guard let data = response.result.value else
                    {
                        //self.loginAlert("Login Failed")
                        self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.LoginSuccessful, resutl: "Login Failed", type:endpoint)
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
                            print("Invalid Username")
                            //self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.ErrorInvalidUsername, resutl: "Invalid Username", type:endpoint)
      
                        case 2:
                            //self.loginAlert("Invalid Password")
                            print("Invalid Password")
                            //self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.ErrorInvalidPassword, resutl: "Invalid Password", type:endpoint)
                        default:
                            //self.loginAlert("Login Failure")
                            print("Login Failure")
                            //self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.LoginFailed, resutl: "Login Failure", type:endpoint)
                        }
                         
                        return
                    }
                     
                    print(self.json["data"])
                      
                    let name = self.json["data"]["user_login"].string    
                    
                    print(name)

                    //self.delegateServer?.remoteLoginResponse(Motion.Message_.ResponseType.LoginSuccessful, resutl: name!, type:endpoint)
                    
                    if name == self.userServer
                    {
                        self.checkLoginiOS("users")
                    
                    } else if endpoint == "client"
                    {
                        self.createWPClient()
                    }
            }
        }
    }
  
    func createWPUser()
    {
        let user:PFUser  = PFUser.currentUser()!

        self.userName = "\(user.username!)"
        self.passWord = randomStringWithLength(20) as String

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
                        let email = quser["email"] as! String
                        print("email \(email)")
                        let first_name = quser["first_name"] as! String
                        let last_name = quser["last_name"] as! String

                        print("userServer: \(self.userServer)")
                        print("passServer: \(self.passServer)")
                        print("user: \(self.userName)")
                        print("pass: \(self.passWord)")
                        print("email: \(email)")

                        var roles : NSMutableArray = ["administrator","editor", "author","contributor","subscriber"]

                        let parameters = [
                            "username": "\(self.userName)",
                            "email": "\(email)",
                            "password": "\(self.passWord)",
                            "first_name": "\(first_name)",
                            "last_name": "\(last_name)",
                            "roles": roles
                        ]
                  
                        print("myWordPressSite: \(self.myWordPressSite)")
                  
                        var usersWordpress:String = "\(self.myWordPressSite)users"
                         
                        print("usersWordpress: \(usersWordpress)")

                        print("\(self.userServer):\(self.passServer)")

                        //let credentials = "\(self.userServer):\(self.passServer)"
                  
                        let credentials = "jose:joselon"

                        //let credentialData = credentials.dataUsingEncoding(NSUTF8StringEncoding)!
                        //let base64Credentials = credentialData.base64EncodedStringWithOptions([])
                  
                        let plainData = (credentials as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                        print(base64String) // bXkgcGxhbmkgdGV4dA==

                        let headers = ["Authorization": "Basic \(base64String)"]
                  
                        print("\(parameters)")
                        print("\(headers)")     
                  
                        Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
                            .responseJSON { response in
                  
                            if response.result.isSuccess
                            {

                                if let value: AnyObject = response.result.value 
                                {
                                    // handle the results as JSON, without a bunch of nested if loops
                                    let post = JSON(value)
                                    print("The post is: " + post.description)
                                
                                    if let userId = post["id"].int
                                    {
                  
                                        print(userId)
                                        
                                        dispatch_async(dispatch_get_main_queue()) 
                                        { 
                                            let pfuser:PFUser  = PFUser.currentUser()!
                                            pfuser.setObject(self.passWord, forKey: "wp_password")
                                            pfuser.setObject(userId, forKey: "wp_id")
                      
                                            pfuser.saveInBackgroundWithBlock
                                            {
                                                (success: Bool , error: NSError?) -> Void in
                                                 
                                                if success
                                                {
                                                    NSUserDefaults.standardUserDefaults().setObject(user, forKey: "wp_username")
                                                    NSUserDefaults.standardUserDefaults().setObject(self.passWord, forKey: "wp_password")
                                                    NSUserDefaults.standardUserDefaults().synchronize()

                                                    /*Alamofire.request(.POST, usersWordpress, parameters: ["check_login": 3])
                                                        .responseJSON { response in

                                                        
                                                        self.remoteLoginiOS(self.userName, password: self.passWord, endpoint:"client")

                                                    }*/

                                                    self.createWPClient()

                                                    //self.checkLoginiOs("client")
                                                }
                                            }
                                        }
                                    } else if let message = post["message"].string
                                    {
                                        self.delegateServer.popover(message)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createWPClient()
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

                        let first_name = quser["first_name"] as! String
                        let last_name = quser["last_name"] as! String
                        
                        
                        let email = quser["email"] as! String

                        let wp_username = quser["username"] as! String
                        let wp_password = quser["wp_password"] as! String

                        let geopoint = quser["location"] as! PFGeoPoint

                        let locationcoords = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude)

                        print("first_name: \(first_name)")
                        print("last_name: \(last_name)")
                        print("username: \(wp_username)")
                        print("email: \(email)")
                        print("location: \(locationcoords)")

                        print("wp_password: \(wp_password)")

                        var parameters = [
                            "client_first_name": "\(first_name)",
                            "client_last_name": "\(last_name)",
                            "client_user_name": "\(wp_username)",
                            //"client_authdata": "\(authData)",
                            "client_email": "\(email)",
                            //"client_thumbnail_url": "",
                            //"client_thumbnail_id": "",
                            "client_location": "\(locationcoords.latitude),\(locationcoords.longitude)",
                            "status" : "publish"
                        ]
                  
                        print("myWordPressSite: \(self.myWordPressSite)")
                  
                        var usersWordpress:String = "\(self.myWordPressSite)/client/"
                        
                        let wp_registered_user = self.defaults.stringForKey("wp_username") 
                        let wp_registered_pass = self.defaults.stringForKey("wp_password") 

                        print("wp_registered_user: \(wp_registered_user!)")
                        print("wp_registered_pass: \(wp_registered_pass!)")

                        //let credentialData = "jose:joselon".dataUsingEncoding(NSUTF8StringEncoding)!
                        //let base64Credentials = credentialData.base64EncodedStringWithOptions([])
                  
                        //let headers = ["Authorization": "Basic \(base64Credentials)"]
                  
                        //let username = wp_registered_user
                        //let password = wp_registered_pass

                        print("\(self.userServer):\(self.passServer)")

                        let credentialData = "\(self.userServer):\(self.passServer)".dataUsingEncoding(NSUTF8StringEncoding)!                  
                        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
                        let headers = ["Authorization": base64Credentials]

                        print(parameters)
                        print(headers)
                  
                        Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
                            .responseJSON { response in
                  
                            if response.result.isSuccess
                            {

                                if let value: AnyObject = response.result.value 
                                {
                                    // handle the results as JSON, without a bunch of nested if loops
                                    let post = JSON(value)
                                    print("The post is: " + post.description)
                                
                                    if let clientId = post["wp_client_id"].int
                                    {
                                        dispatch_async(dispatch_get_main_queue()) 
                                        { 
                                            let pfuser:PFUser  = PFUser.currentUser()!
                                            pfuser.setObject(clientId as! String, forKey: "wp_client_id")
                                        
                                            pfuser.saveInBackgroundWithBlock
                                            {
                                                (success: Bool , error: NSError?) -> Void in
                                                 
                                                if success
                                                {
                                                    print("User updated password")
                    
                                                    parameters["wp_client_id"] = String(clientId)
                                                    
                                                    self.defaults.setObject(parameters, forKey: "registered_user")

                                                    self.delegateServer.registrationCompleted()
                                                }
                                            }
                                        }
                                    } else if let message = post["message"].string
                                    {
                                        self.delegateServer.popover(message)
                                    }   
                                }
                            }
                        }
                    }
                }
            }
        }
    }


  func postClientThumbnail(
        userServer:String, 
        passServer:String,  
        name: String, 
        image: UIImage?)
    {

        //media << "curl --user jose:joselon -X POST -H 'Content-Disposition: filename=" << fineandextension << 
        //        "' --data-binary @'"<< maximagepath << "' -d title='" << recname << "' -H \"Expect: \" " << SERVER_BASE_URL << "/wp-json/wp/v2/media";
      
        var usersWordpress:String = "\(self.myWordPressSite)/media/"

    	let username = "jose"
    	let password = "joselon"

    	let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!                  
    	let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    	let headers = ["Authorization": base64Credentials]

    	//let imageData:NSData = UIImagePNGRepresentation(image!)!

    	var imageV : UIImageView = UIImageView(image: image)

    	let myImageName = "image.png"
        let imagePath = fileInDocumentsDirectory(myImageName)
        
        if let image = imageV.image {
        	saveImage(image, path: imagePath)
        } else { print("some error message") }
        
        /*var imageDisk = String()
        if let loadedImage = loadImageFromPath(imagePath) 
        {
            print(" Loaded Image: \(loadedImage)")
            imageDisk = "\(loadedImage)"
        } else { 
        	print("some error message 2") 
        }*/

        print(imagePath)
            
    	Alamofire.upload(
    	    .POST,
    	    usersWordpress,
    	    headers: headers,
    	    multipartFormData: { multipartFormData in
    	        let data = "default".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    	        multipartFormData.appendBodyPart(data: data, name: "_formname")
    	        multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: imagePath), name: "image")
    	    },
    	    encodingCompletion: { encodingResult in
    	        switch encodingResult {

    	        case .Success(let upload, _, _):
    	            upload.responseString { response in
    	                debugPrint(response)
    	            }

    	        case .Failure(let encodingError):
    	            print(encodingError)
    	        }
    	    }
    	)

   }

    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }

    func fileInDocumentsDirectory(filename: String) -> String {
    
    	let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    	return fileURL.path!
    
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
    
    func getDocumentsURL() -> NSURL {
    	let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    	return documentsURL
	}
   
    
}

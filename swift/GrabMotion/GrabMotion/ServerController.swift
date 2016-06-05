//
//  ServerController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/15/16.
//  Copyright ĂĹ  2016 GrabMotion Computer Vision. All rights reserved.
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
   
    var userServer  = String()
    var passServer  = String()
    var passWord    = String()
    var userName    = String()
     
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
   
    var delegateServer:ServerControllerDelegate! = nil
   
    var myWordPressSite:String = "http://grabmotion.co/wp-json/wp/v2/"
  
    let defaults = NSUserDefaults.standardUserDefaults()
      
    lazy var json : JSON = JSON.null
  
    var profileImage:UIImage!
  
    var deviceIp = String()

    var CLIENT_PARENT = 0 // CHANGE THIS WHEN A HEIGHER OBJECT IS CREATED
   
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
  
    func setProfilePicture( image : UIImage )
    {
        self.profileImage = image
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
                guard let name = self.json["data"]["user_login"].string else 
                {
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
                
                   
                let name = self.json["data"]["user_login"].string    
                 
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
                        let email = "josemauelvigil@gmai.com" //quser["email"] as! String
                        //print("email \(email)")
                        let first_name = quser["first_name"] as! String
                        let last_name = quser["last_name"] as! String
  
                        print("userServer: \(self.userServer)")
                        print("passServer: \(self.passServer)")
                        print("user: \(self.userName)")
                        print("pass: \(self.passWord)")
                        print("email: \(email)")
  
                        let parameters = [
                            "check_login": 3,
                            "ios_userlogin":"\(self.userServer)",
                            "ios_userpassword":"\(self.passServer)",
                            "new_username":"\(self.userName)",
                            "new_password":"\(self.passWord)",
                            "new_email":"\(email)",
                            "new_first_name":"\(first_name)",
                            "new_last_name":"\(last_name)",
                            "new_role":"editor"
                        ]
               
                        print("\(parameters)")   
  
                        print("++++++++++++++++++++++++++++++++++++++++")             
  
                        let usersURL =  "\(self.myWordPressSite)users"
                        
                        print(usersURL)
                   
                        var request = Alamofire.request(.POST, usersURL, parameters: parameters as? [String : AnyObject])
                            .responseJSON { response in
                
                            print(response)
                                
                            if response.result.isSuccess
                            {
  
                                if let value: AnyObject = response.result.value 
                                {
                                    let post = JSON(value)
  
                                    print(post)
  
        	                        if let message = post["message"].string
                                    {
                                        self.delegateServer.popover(message)
  
                                    } else 
                                    {
                                        let userId = post.description
                   
                                        print("The post is: " + post.description)
  
                                        dispatch_async(dispatch_get_main_queue()) 
                                        { 
                                            
                                            self.defaults.setObject(self.userName, forKey: "wp_username")
                                            self.defaults.setObject(self.passWord, forKey: "wp_password")
                                            self.defaults.setObject(self.userName, forKey: "wp_user")
                                            self.defaults.setObject(Int(userId),   forKey: "wp_userid")
                                            self.defaults.setObject(self.myWordPressSite, forKey: "wp_server_url")
                                            self.defaults.synchronize()
  
                                            self.createWPClient()

                                        }
                                    }
                                }
                            }
                        }
                        print(request)
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
                         
                        let email = "josemanuelvigil@gmail.com" //quser["email"] as! String
  
                        let wp_username = quser["username"] as! String

                        var wp_password = self.defaults.stringForKey("wp_password")! as String                        

                        let wp_userid = self.defaults.stringForKey("wp_userid")! as String
                        
                        print(wp_userid)
  
                        let geopoint = quser["location"] as! PFGeoPoint
  
                        let location = "\(geopoint.latitude),\(geopoint.longitude)"
  
                        print("first_name: \(first_name)")
                        print("last_name: \(last_name)")
                        print("username: \(wp_username)")
                        print("email: \(email)")
                        print("location: \(location)")
                        print("wp_password: \(wp_password)")
  
                        var parameters = [
                            "check_login": 4,
                            "wp_userlogin":self.userName,
                            "wp_userpassword":self.passWord,
                            "post_author":"\(wp_userid)",
                            "client_first_name": "\(first_name)",
                            "client_last_name": "\(last_name)",
                            "client_user_name": "\(wp_username)",
                            "client_email": "\(email)",
                            "client_location":location,
                            "client_post_parent": self.CLIENT_PARENT
                        ]
                   
                        print("parameters: \(parameters)")
                   
                        var usersWordpress:String = "\(self.myWordPressSite)client/"
                         
                        print("usersWordpress: \(usersWordpress)")
                                          
                        var request = Alamofire.request(.POST, usersWordpress, parameters: parameters as! [String : AnyObject])
                            .responseJSON { response in

                            print("\(response)")
                             
                            if response.result.isSuccess
                            {
  
                                if let value: AnyObject = response.result.value 
                                {
                                    // handle the results as JSON, without a bunch of nested if loops
                                    let post = JSON(value)
  
                                    print(post)

                                    if let clientId = post["ID"].int
                                    {

                                        let urlClient = "\(usersWordpress)\(clientId)"

                                        print("urlClient: \(urlClient)")

                                        Alamofire.request(.GET, urlClient) //, parameters: nil as! [String : AnyObject])
                                        .responseJSON { response in

                                            print("JSON: \(response)")
                             
                                            if response.result.isSuccess
                                            {
                  
                                                if let value: AnyObject = response.result.value 
                                                {
                                                    
                                                    let clientPost = JSON(value)

                                                    let iId         = clientPost["id"].int                                  
                                                    let wp_modified = clientPost["modified"].string         
                                                    let wp_type     = clientPost["type"].string                                             
                                                    let wp_slug     = clientPost["slug"].string                                     
                                                    let wp_link     = clientPost["link"].string                                                   

                                                    var wp_api_link = String()

                                                    for href in clientPost["_links"]["self"].arrayValue 
                                                    {
                                                        print(href["href"].stringValue)
                                                        wp_api_link = href["href"].stringValue
                                                    }

                                                    var wp_post_parent = Int()

                                                    for pparent in clientPost["post_parent"].arrayValue 
                                                    {
                                                        print(pparent.intValue)
                                                        wp_post_parent = pparent.intValue
                                                    }
                                                    
                                                    let wp_featured_media  = clientPost["featured_media"].int
                                                    print(wp_featured_media)

                                                    
                                                    let wp_server_url     = self.defaults.stringForKey("wp_server_url")! as String
                                                    let wp_user = self.defaults.stringForKey("wp_username")! as String                        
                                                    let wp_pass = self.defaults.stringForKey("wp_password")! as String                        
                                                    
                                                    let clt = PFObject(className: "Client")
                                                    clt.setObject(wp_user, forKey: "wp_user")                                                    
                                                    clt.setObject(wp_pass, forKey: "wp_password")                                                    
                                                    clt.setObject(iId!, forKey: "wp_client_id")
                                                    clt.setObject(Int(wp_userid)!, forKey: "wp_userid")             
                                                    clt.setObject(wp_server_url, forKey: "wp_server_url")
                                                    clt.setObject(wp_modified!, forKey: "wp_modified")                                                    
                                                    clt.setObject(wp_type!, forKey: "wp_type")
                                                    clt.setObject(wp_slug!, forKey: "wp_slug")
                                                    clt.setObject(wp_link!, forKey: "wp_link")
                                                    clt.setObject(wp_api_link, forKey: "wp_api_link")
                                                    clt.setObject(wp_featured_media!, forKey: "wp_client_media_id")
                                                    clt.setObject(wp_post_parent, forKey: "wp_post_parent")
                                                  
                                                    clt.saveInBackgroundWithBlock ({
                                                        (success: Bool, error: NSError?) -> Void in
                                                        
                                                        if success == true
                                                        {
                                                            self.uploadProfilePicture(clt, clientId:Int(iId!), post_author : Int(wp_userid)! )
                                                        }
                                                    })  
                                                }
                                            }
                                        }
                                         
                                    } else if let message = post["message"].string
                                    {
                                        self.delegateServer.popover(message)
                                    }   

                                } else 
                                {
                                    self.delegateServer.popover("\(response)")
                                }   
                            }
                        }
                        print(request)
                    }
                }
            }
        }
    }
  
    func uploadProfilePicture( client:PFObject, 
        clientId:Int, 
        post_author:Int)
    {
  
  
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) 
        {
                       
            dispatch_async(dispatch_get_main_queue()) 
            {
  
                let imageData = UIImagePNGRepresentation(self.profileImage)
  
                let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
  
                print("post_author: \(post_author)")
  
                var parameters = [
                    "check_login": 5,
                    "media_userlogin":self.userName,
                    "media_userpassword":self.passWord,
                    "image" : base64String,
                    "postId" : clientId,
                    "post_author" : post_author
                ]
           
                print("parameters: \(parameters)")
           
                var usersWordpress:String = "\(self.myWordPressSite)media/"
                 
                print("usersWordpress: \(usersWordpress)")
                                  
                Alamofire.request(.POST, usersWordpress, parameters: parameters as! [String : AnyObject])
                    .responseJSON { response in
  
                    print(response)
  
                    if response.result.isSuccess
                    {
  
                        if let value: AnyObject = response.result.value
                        {
        
                            let post = JSON(value)
  
                            print(post)
                         
                            if let mediaId = post["ID"].int
                            {
                                    
                                client.setObject(mediaId, forKey: "wp_client_media_id")
                 
                                client.saveInBackgroundWithBlock
                                {
                                    (success: Bool , error: NSError?) -> Void in
                                      
                                    if   success
                                    {
                                        print("User Setup Finished.")         

                                        let user:PFUser  = PFUser.currentUser()!

                                        let userRel:PFRelation = user.relationForKey("client")
                                        userRel.addObject(client)

                                        user.saveInBackgroundWithBlock
                                        {
                                            (success: Bool , error: NSError?) -> Void in
                                              
                                            if success
                                            {
                                                self.delegateServer.registrationCompleted()  
                                            }
                                        }
                                    }
                                }
             

                            } else if let message = post["message"].string
                            {
                                self.delegateServer.popover(message)
                            }
                                
                        } else 
                        {
                            self.delegateServer.popover("\(response)")
                        }   
                    }
                }
            }    
        }
    }
  

    func randomStringWithLength (len : Int) -> NSString {
  
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  
        var randomString : NSMutableString = NSMutableString(capacity: len)
  
        for (var i=0; i < len; i++)
        {
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
  
        return randomString
    }
  
    //https://github.com/Alamofire/Alamofire/issues/32
  
    /*func postClientThumbnail(
        userServer:String, 
        passServer:String,  
        name: String, 
        image: UIImage?)
    {
  
        //media << "curl --user " << WP_USER << ":" << WP_PASS << " -X POST -H 'Content-Disposition: filename=" << fineandextension << 
        //        "' --data-binary @'"<< maximagepath << "' -d title='" << recname << "' -H \"Expect: \" " << SERVER_BASE_URL << "media";
       
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
         
        var imageDisk = String()
        if let loadedImage = loadImageFromPath(imagePath) 
        {
            print(" Loaded Image: \(loadedImage)")
            imageDisk = "\(loadedImage)"
        } else { 
            print("some error message 2") 
        }
  
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
  
    
     
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }*/
    
     
}

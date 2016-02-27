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
    func checkLoginResponse(response:Int, resutl:String) 
    func remoteLoginResponse(reponsetype: Motion.Message_.ResponseType, resutl: String)
    func registrationCompleted()
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
  
  
    func createUser(
        userServer:String,
        passServer:String,  
        user:String,
        pass:String,  
        email:String,
        first_name:String,
        last_name:String
        )
    {
         
        print("userServer: \(userServer)")
        print("passServer: \(passServer)")
        print("user: \(user)")
        print("pass: \(pass)")
        print("email: \(email)")
  
        let parameters = [
            "username": "\(user)",
            "email": "\(email)",
            "password": "\(pass)",
            "first_name": "\(first_name)",
            "last_name": "\(last_name)",
            "capabilities":"author",
            "description":"User created with iOS client versio 1.0.0"
        ]
  
        print("myWordPressSite: \(self.myWordPressSite)")
  
        var usersWordpress:String = "\(self.myWordPressSite)users/"
         
        print("usersWordpress: \(usersWordpress)")
  
        let credentialData = "\(userServer):\(passServer)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
  
        let headers = ["Authorization": "Basic \(base64Credentials)"]
  
        print("\(parameters)")
        print("\(headers)")
  
        Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
            .responseJSON { response in
  
            print(response)
  
             if let JSON = response.result.value 
             {
                print("JSON: \(JSON)")
  
                if response.result.isSuccess
                {
                     
                    let response = JSON as! NSDictionary
  
                    let userId = response.objectForKey("id")!
  
                    dispatch_async(dispatch_get_main_queue()) 
                    { 
                        let pfuser:PFUser  = PFUser.currentUser()!
                        pfuser.setObject(pass as String, forKey: "wp_password")
                        pfuser.setObject(userId, forKey: "wp_id")
  
                        pfuser.saveInBackgroundWithBlock
                        {
                            (success: Bool , error: NSError?) -> Void in
                             
                            if success
                            {
                                print("User updated password")
                                self.remoteLogin(user, password: pass as String)
                            }
                        }
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
  
    /*func postClientThumbnail(
        userServer:String, 
        passServer:String,  
        name: String, 
        image: UIImage?)
    {
  
        //media << "curl --user jose:joselon -X POST -H 'Content-Disposition: filename=" << fineandextension << 
        //        "' --data-binary @'"<< maximagepath << "' -d title='" << recname << "' -H \"Expect: \" " << SERVER_BASE_URL << "/wp-json/wp/v2/media";
  
        let imagePath = fileInDocumentsDirectory("\(name).png")
  
        if image != nil 
        {
            // Save it to our Documents folder
            let result = saveImage(image!, path: imagePath)
             
            if result
            {
             
                print("Image saved? Result: (result)")    
  
                let imageext = "filename=\(name).png"
  
                 let parameters = [
                    "Content-Type": "data-binary @\(imagePath)",
                    "Content-Disposition": imageext,
                    "Expect": " ",
                    "title" : name
                ]
  
                print("myWordPressSite: \(self.myWordPressSite)")
  
                var usersWordpress:String = "\(self.myWordPressSite)media/"
                 
                print("usersWordpress: \(usersWordpress)")
  
                print("userServer: \(userServer)")
                print("passServer: \(passServer)")
  
                let credentialData = "\(userServer):\(passServer)".dataUsingEncoding(NSUTF8StringEncoding)!
                let base64Credentials = credentialData.base64EncodedStringWithOptions([])
  
                let headers = ["Authorization": "Basic \(base64Credentials)"]
  
                print("******************************")
                print("\(parameters)")
                print("\(headers)")
                print("******************************")
  
                Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
                    .responseJSON { response in
  
                    print(response)
                }
            }
  
        }
    }*/
  
    /*func postClientThumbnail(
        userServer:String, 
        passServer:String,  
        name: String, 
        image: UIImage?)
    {
           
  
        var usersWordpress:String = "\(self.myWordPressSite)media/"
  
         // This example uploads a file called example.png found in the app resources
     
        //let fileURL = NSBundle.mainBundle().URLForResource("example", withExtension: "png")

        let fileUploader = FileUploader()
         
        // we can add multiple files
        // this would be equivalent to: <input type="file" name="myFile"/>
         
        //fileUploader.addFileURL(fileURL!, withName: "myFile")
         
        // we can add NSData objects directly
        //let data = UIImage(named: "sample")
  
        fileUploader.addFileData( UIImageJPEGRepresentation(image!,0.8)!, withName: "mySecondFile", withMimeType: "image/png" )
         
        // we can also add multiple aditional parameters
        // this would be equivalent to: <input type="hidden" name="folderName" value="sample"/>
        //fileUploader.setValue( "sample", forParameter: "folderName" )
         
        // put your server URL here
        var request = NSMutableURLRequest( URL: NSURL(string: usersWordpress )! )
        request.HTTPMethod = "POST"
         
        fileUploader.uploadFile(request: request)!
            .progress { [weak self] bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                //  To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)....\(totalBytesExpectedToWrite)")
                }
            }
            .responseJSON { [weak self] response in
                debugPrint(response)
                if response.result.isSuccess 
                {
                    print(response.data)
                 
                } else 
                { 
  
                    print(response.result.error)
                }
        }
  
    }*/
  
  func postClientThumbnail(
        userServer:String, 
        passServer:String,  
        name: String, 
        image: UIImage?)
    {

    	//media << "curl --user jose:joselon -X POST -H 'Content-Disposition: filename=" << fineandextension << 
        //        "' --data-binary @'"<< maximagepath << "' -d title='" << recname << "' -H \"Expect: \" " << SERVER_BASE_URL << "/wp-json/wp/v2/media";
  


    	/*let imageData = UIImageJPEGRepresentation(image!, 0.2)
		let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)


		let parameters = [
                    "image": base64String,
                    "Expect": " ",
                    "title" : name
                ]

        var usersWordpress:String = "\(self.myWordPressSite)media/"
         
        print("usersWordpress: \(usersWordpress)")
  
        let credentialData = "jose:joselon".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
  
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        var usersWordpress:String = "\(self.myWordPressSite)media/"

		let credentialData = "jose:joselon".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions(nil)

        let aManager = Manager.sharedInstance
	    aManager.session.configuration.HTTPAdditionalHeaders = [
	        "Authorization": "Bearer \(base64Credentials)" ]

	  
        request(.POST, usersWordpress, encoding: .JSON)
            .responseJSON { response in
  
            print(response)
  
             if let JSON = response.result.value 
             {
                print("JSON: \(JSON)")
  
                if response.result.isSuccess
                {
                	print(response.result)
                }

            }
         }*/

	/*var usersWordpress:String = "\(self.myWordPressSite)media/"

    let request = NSMutableURLRequest(URL: NSURL(string: usersWordpress)!)
    request.HTTPMethod = "POST"
    

    let imageData:NSData = UIImagePNGRepresentation(image!)!

    let boundary = "----------SwIfTeRhTtPrEqUeStBoUnDaRy"
    let contentType = "multipart/form-data; boundary=\(boundary)"
    let body = NSMutableData();

    let tempData = NSMutableData()
    let fileName = "\(image!.description).png"
    let parameterName = "contest-photo"

    let mimeType = "application/octet-stream"
        
    tempData.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    let fileNameContentDisposition = "name=\(fileName)"
    let contentDisposition = "Content-Disposition: form-data; name=\"\(fileName)\"; \(imageData)\r\n"
    tempData.appendData(contentDisposition.dataUsingEncoding(NSUTF8StringEncoding)!)
    tempData.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    tempData.appendData(imageData)
    tempData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

    body.appendData(tempData)

    body.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

    request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")

 	//let credentialData = "jose:joselon".dataUsingEncoding(NSUTF8StringEncoding)!
    //let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    	
    //request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization"

    request.HTTPBody = body

    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
	let userPasswordString = "jose:joselon"
	let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
	let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions([])
	let authString = "Basic \(base64EncodedCredential)"
	config.HTTPAdditionalHeaders = ["Authorization" : authString]

    let session = NSURLSession(configuration: config)

    let task = session.dataTaskWithRequest(request) {
        data, response, error in

        if error != nil {
            print("error=\(error)")
            return
        }

        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print("responseString = \(responseString!)")
        if let JSON = responseString
        {
        	print("JSON: \(JSON)")
        }

    }
    task.resume()*/

    //var imageData = UIImagePNGRepresentation(image!)

    //let base64String = imageData.base64EncodedStringWithOptions(.allZeros)

    /*let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

    let parameters = [
        "img": base64String
    ]

    print("myWordPressSite: \(self.myWordPressSite)")
  
    var usersWordpress:String = "\(self.myWordPressSite)media/"
     
    print("usersWordpress: \(usersWordpress)")

    let credentialData = "jose:joselon".dataUsingEncoding(NSUTF8StringEncoding)!
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])

    let headers = ["Authorization": "Basic \(base64Credentials)"]

    print("\(parameters)")
    print("\(headers)")

    Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
            .responseJSON { response in
  
            print(response)
  
             if let JSON = response.result.value 
             {
                print("JSON: \(JSON)")
  
                if response.result.isSuccess
                {
                }
             }
      }*/

      var usersWordpress:String = "\(self.myWordPressSite)media/"

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




   	func createUser(
        userWodpress:String,
        passWordpress:String,  
        user:String,
        pass:String,  
        email:String,
        first_name:String,
        last_name:String
        )
    {
         
        print("userServer: \(userServer)")
        print("passServer: \(passServer)")
        print("user: \(user)")
        print("pass: \(pass)")
        print("email: \(email)")
  
        let parameters = [
            "client_first_name": "\(first_name)",
            "client_last_name": "\(last_name)",
            "client_user_name": "\()",
            "client_authdata": "\()",
            "client_email": "\()",
            "client_thumbnail_url": "\()",
            "client_thumbnail_id": "\()",
            "client_location": "\()"
        ]
  
        print("myWordPressSite: \(self.myWordPressSite)")
  
        var usersWordpress:String = "\(self.myWordPressSite)client/"
         
        print("usersWordpress: \(usersWordpress)")
  
        let credentialData = "\(userWodpress):\(passWordpress)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
  
        let headers = ["Authorization": "Basic \(base64Credentials)"]
  
        print("\(parameters)")
        print("\(headers)")
  
        Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
            .responseJSON { response in
  
            print(response)
  
             if let JSON = response.result.value 
             {
                print("JSON: \(JSON)")
  
                if response.result.isSuccess
                {
                     
                    let response = JSON as! NSDictionary
  
                    let userId = response.objectForKey("id")!
  
                    dispatch_async(dispatch_get_main_queue()) 
                    { 
                        let pfuser:PFUser  = PFUser.currentUser()!
                        pfuser.setObject(pass as String, forKey: "wp_password")
                        pfuser.setObject(userId, forKey: "wp_id")
  
                        pfuser.saveInBackgroundWithBlock
                        {
                            (success: Bool , error: NSError?) -> Void in
                             
                            if success
                            {
                                print("User updated password")
                                self.remoteLogin(user, password: pass as String)
                            }
                        }
                    }
                }
            }
        }
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
	}
   
    func createClient(
        userServer:String,
        passServer:String,
        user:String,
        pass:String,  
        email:String,
        first_name:String,
        last_name:String)
    {
         
        print("userServer: \(userServer)")
        print("passServer: \(passServer)")
        print("user: \(user)")
        print("pass: \(pass)")
        print("email: \(email)")
  
        let parameters = [
            "username": "\(user)",
            "email": "\(email)",
            "password": "\(pass)",
            "first_name": "\(first_name)",
            "last_name": "\(last_name)",
            "capabilities":"author",
            "description":"User created with iOS client versio 1.0.0"
        ]
  
        print("myWordPressSite: \(self.myWordPressSite)")
  
        var usersWordpress:String = "\(self.myWordPressSite)users/"
         
        print("usersWordpress: \(usersWordpress)")
  
        let credentialData = "\(userServer):\(passServer)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
  
        let headers = ["Authorization": "Basic \(base64Credentials)"]
  
        print("\(parameters)")
        print("\(headers)")
  
        Alamofire.request(.POST, usersWordpress, parameters: parameters, headers: headers)
            .responseJSON { response in
  
            print(response)
  
             if let JSON = response.result.value 
             {
                print("JSON: \(JSON)")
  
                if response.result.isSuccess
                {
                     
                    let response = JSON as! NSDictionary
  
                    let userId = response.objectForKey("id")!
  
                    dispatch_async(dispatch_get_main_queue()) 
                    { 
                        let pfuser:PFUser  = PFUser.currentUser()!
                        pfuser.setObject(pass as String, forKey: "wp_password")
                        pfuser.setObject(userId, forKey: "wp_id")
  
                        pfuser.saveInBackgroundWithBlock
                        {
                            (success: Bool , error: NSError?) -> Void in
                             
                            if success
                            {
                                print("User updated password")
                                self.remoteLogin(user, password: pass as String)
                            }
                        }
                    }
                }
            }
        }
    }
  
    

    


    func postClientData()
    {
  
  
  
    }
     
    /*func loginAlert(alertMessage: String)
    {
        let loginAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
         
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
         
        loginAlert.addAction(okAction)
         
        self.presentViewController(loginAlert, animated: true, completion: nil)
    }*/
  
}

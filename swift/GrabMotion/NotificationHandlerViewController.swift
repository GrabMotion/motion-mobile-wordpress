//
//  NotificationViewController.swift
//  Burt
//
//  Created by Macbook Pro DT on 3/22/16.
//  Copyright © 2016 layer. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class NotificationViewController: UIViewController
{

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var targetVC: UIViewController!

    lazy var json : JSON = JSON.null 

    let defaults = NSUserDefaults.standardUserDefaults()   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }   
    
    func processNotification(userInfo: [NSObject : AnyObject],
        targetVC: UIViewController)
    {        
       
        self.targetVC = targetVC
        
        let endinstance         = userInfo["endinstance"] as? String
        let endrec              = userInfo["endrec"] as? String
        let endcamera           = userInfo["endcamera"] as? String  

        var pushe = Push() 

        let user = self.defaults.stringForKey("wp_username")! as String                        
        let password = self.defaults.stringForKey("wp_password")! as String                     
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]     

        Alamofire.request(.GET, endinstance!, headers: headers)
            .validate()
            .responseJSON { response in

             debugPrint(response)

             let data = response.result.value

             self.json = JSON(data!)

             //self.json["logged_in"]

        }  
        
    }
    
}

//
//  MainViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/3/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Parse
import SwiftyJSON

class MainViewController: UITabBarController
{

    let defaults = NSUserDefaults.standardUserDefaults()

    var SETUP               = 0
    var DEVICES             = 1
    var NOTIFICATIONS       = 2
    var PROFILE             = 3

    var setupViewController:SetupViewController?
    var deviceViewController:DeviceViewController?
    var pushNotificationViewController:PushNotificationViewController?
    var proFileViewController:ProFileViewController?

    override func viewDidLoad() { 
        super.viewDidLoad()
    
        self.setupViewController =  self.viewControllers![SETUP] as? SetupViewController
        self.setupViewController!.mainController = self
        
        self.deviceViewController   = self.viewControllers![DEVICES] as? DeviceViewController
        self.deviceViewController!.mainController = self

        self.pushNotificationViewController  = self.viewControllers![NOTIFICATIONS] as? PushNotificationViewController
        self.pushNotificationViewController!.mainController = self  

        self.proFileViewController = self.viewControllers![PROFILE] as? ProFileViewController
        self.proFileViewController!.mainController = self

    
        let profile_stored:Bool = defaults.boolForKey("profile_data_stored")
        if !profile_stored
        {   
            self.tabBar.userInteractionEnabled = false
            self.selectedIndex = 3
            return
        } 

        let profile_finished:Bool = defaults.boolForKey("profile_finished")
        if !profile_finished
        {   
            self.tabBar.userInteractionEnabled = false
            self.selectedIndex = 3
            return
        } else 
        {
            self.tabBar.userInteractionEnabled = false
            self.selectedIndex = 1
            return
        }

        let setup_finished:Bool = defaults.boolForKey("setup_finished")
        if !setup_finished
        {   
            self.tabBar.userInteractionEnabled = false
            self.selectedIndex = 1
        } else 
        {
            self.tabBar.userInteractionEnabled = true 
            self.selectedIndex = 2
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

}

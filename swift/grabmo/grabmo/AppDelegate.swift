//
//  AppDelegate.swift
//  grabmo
//
//  Created by Jose Vigil on 6/3/16.
//  Copyright © 2016 GrabMotion. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var geoPoint = PFGeoPoint()
    var annotation = MKPointAnnotation()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var ParseApplicationId  = "fsLv65faQqwqhliCGF7oGqcT8MxPDFjmcxIuonGw"
    var ParseClientKey      = "T3PK1u0NQ36eZm91jM0TslCREDj8LBeKzGCsrudE"
    var RestApiKey          = "ZRfqjSe0ju8XejHHmJdsfzsYKYsQYBWsYLU40FDB"

    var localaddrip = String()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId(ParseApplicationId, clientKey: ParseClientKey)
        
        PFTwitterUtils.initializeWithConsumerKey("MDtm7P8102QqmviczXiPKNuBB", consumerSecret:"sPrMVRaDwKMYtQZSNSQLheNiHDxCyg9M8C2XNrG1HqnP2DHQ9K")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let userNotificationTypes: UIUserNotificationType = [.Badge, .Sound]
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        self.setGeoLocation()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive
        {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        if let pushText = userInfo["data"] as? String
        {
            
            let notiHandler = NotificationViewController()
            
        }
        
    }
    
    func setGeoLocation()
    {
        
        
        let location_authorized = defaults.boolForKey("location_authorized")
        if location_authorized
        {
            
            if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()) || (FBSDKAccessToken.currentAccessToken() != nil)
            {
                
                if (PFUser.currentUser() == nil)
                {
                    
                    PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                        
                        if (geoPoint != nil)
                        {
                            print("\(geoPoint)")
                            
                            self.geoPoint = geoPoint!
                            
                            self.annotation.coordinate = CLLocationCoordinate2DMake(geoPoint!.latitude, geoPoint!.longitude)
                            
                            let pfuser = PFUser.currentUser()
                            
                            if pfuser != nil
                            {
                                
                                print("geoPoint: \(self.geoPoint)")
                                
                                print("username: \(pfuser!.username)")
                                
                                pfuser!.setObject(self.geoPoint, forKey: "location")
                                
                                pfuser!.saveInBackgroundWithBlock
                                    {
                                        (success: Bool, error: NSError?) -> Void in
                                        
                                        if (success)
                                        {
                                            print("location stored")
                                            
                                        } else
                                        {
                                            print("location cannot be stored")
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


}


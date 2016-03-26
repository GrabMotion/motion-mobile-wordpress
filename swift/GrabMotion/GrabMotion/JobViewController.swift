//
//  JobViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 3/25/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse

class JobViewController: UIViewController,
SocketProtocolDelegate  
{
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var progress: UIView!

    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var percentage: UILabel!
      
    var device = Device()

    var socket = Socket()

    var deviceIp = String()

	override func viewDidLoad()
    {
    	super.viewDidLoad()
    	
    	self.socket.delegate = self

        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        self.percentage.text = "0%"
    }


    override func shouldAutorotate() -> Bool {
        return true
    }
    
    @IBAction func shot(sender: AnyObject)
    {
        socket.deviceIp = deviceIp
        socket.setLocaladdrip(self.appDelegate.localaddrip)

        let message = Motion.Message_.Builder()
        message.types = Motion.Message_.ActionType.TakePicture
        message.serverip = deviceIp
    }
    
    @IBAction func back(sender: AnyObject)
    {
        
    }
    
    
    @IBAction func add(sender: AnyObject)
    {
        
    }
    
    
    
    
    
    @IBAction func save(sender: AnyObject)
    {
        
    }  
    
    func simpleMessageReceived(message: Motion.Message_)
    {

    }

    func imageProgress(progress : Int,  total : Int)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
        
            dispatch_async(dispatch_get_main_queue(), {
              
              return
            })
        })
        
    }

}

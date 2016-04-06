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

    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentage: UILabel!

    @IBOutlet weak var nameInput: UITextField!
    
    var device = Device()

    var socket = Socket()    

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

        let message = Motion.Message_.Builder()
        message.types = Motion.Message_.ActionType.TakePicture
        message.serverip = self.device.ipnumber
        message.packagesize = self.socket.packagesize //Int32(Motion.Message_.SocketType.SocketBufferMicroSize.rawValue) //self.socket.packagesize
        message.includethubmnails = false
        
        let error:NSError!

        var data:NSData!
        do
        {
            let m = try message.build()
            data = m.data()

        } catch
        {
            print(error)
        }
        
        if (data != nil)
        {
            print(data.length)
        }

        self.socket.deviceIp = self.device.ipnumber
        print(self.device.ipnumber)
        self.socket.setLocaladdrip(self.appDelegate.localaddrip)        
        self.socket.sendMessage(data)

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
        print("recevied")
        
        let camerastr:String = self.socket.files[0]

        let cameraImage:UIImage = CVWrapper.processImageWithStrToCVMat(camerastr)
                        
        self.image.image = cameraImage
    }

    func imageProgress(progress : Int,  total : Int)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
        
            dispatch_async(dispatch_get_main_queue(), {
              
                self.progressView.setProgress(Float(progress), animated: true)
                let progressValue = self.progressView.progress
                self.percentage?.text = "\(progressValue * 100) %"

              return
            })
        })
        
    }

}

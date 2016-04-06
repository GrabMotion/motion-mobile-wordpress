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
UITextFieldDelegate,
SocketProtocolDelegate  
{
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var progressView: UIProgressView!

    @IBOutlet weak var percentage: UILabel!

    @IBOutlet weak var nameInput: UITextField!
    
    var device = Device()
    var camera = Camera()

    var socket = Socket()    

    var id_mat = Int32()

    var matrows = Int32()
    var matcols = Int32()

    var matheight = Int32()
    var matwidth = Int32()

    var motioncameras:[Motion.Message_.MotionCamera]!

	override func viewDidLoad()
    {
    	super.viewDidLoad()
    	
    	self.socket.delegate = self

        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        self.percentage.text = "0%"

        let activecam = self.device.activecam
        self.camera = self.device.cameras[activecam]

        print("recevied")   

        self.id_mat     = Int32(self.device.cameras[activecam].idmat)
        print(self.id_mat)
        self.matrows    = Int32(self.device.cameras[activecam].matrows)
        print(self.matrows)
        self.matcols    = Int32(self.device.cameras[activecam].matcols)
        print(self.matcols)
        self.matheight  = Int32(self.device.cameras[activecam].matheight)
        print(self.matheight)
        self.matwidth   = Int32(self.device.cameras[activecam].matwidth)
        print(self.matwidth) 
              
    }


    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool 
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func shot(sender: AnyObject)
    {       

        let msg_picure = Motion.Message_.Builder()
        msg_picure.types = Motion.Message_.ActionType.TakePicture
        msg_picure.serverip = self.device.ipnumber
        msg_picure.packagesize = self.socket.packagesize //Int32(Motion.Message_.SocketType.SocketBufferMicroSize.rawValue) //self.socket.packagesize
        msg_picure.includethubmnails = false
        
        let error:NSError!

        var data:NSData!
        do
        {
            let m = try msg_picure.build()
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


        
        let msg_save = Motion.Message_.Builder()
        msg_save.types = Motion.Message_.ActionType.Save
        msg_save.serverip = self.device.ipnumber
        msg_save.packagesize = self.socket.packagesize //Int32(Motion.Message_.SocketType.SocketBufferMicroSize.rawValue) //self.socket.packagesize
        msg_save.includethubmnails = false

        let error:NSError!

        // CAMERA

        //let pcam = Motion.Message_.MotionCamera.Builder()      

        let pcam:Motion.Message_.MotionCamera = Motion.Message_.MotionCamera.Builder

        pcam.cameranumber     = Int32(self.camera.cameranumber)
        //Int(rcamera.cameranumber)
        pcam.cameraname     = self.camera.cameraname   
        pcam.recognizing    = self.camera.recognizing

        do
        {                            
            try msg_save.motioncamera += [pcam.build()]
        } catch
        {
            print(error)
        }
    
        
        // RECOGNITION

        let pfrec = Motion.Message_.MotionRec.Builder()

        pfrec.dbIdmat       =  self.id_mat
        pfrec.activerec     =  1
        pfrec.speed         =  self.socket.packagesize
        pfrec.hasregion     =  false
        pfrec.codename      =  "test"
        pfrec.delay         =  2
        pfrec.storevideo    =  true
        pfrec.storeimage    =  true
        pfrec.recname       =  self.nameInput.text!
        pfrec.matrows       =  self.matrows
        pfrec.matcols       =  self.matcols
        pfrec.matheight     =  self.matheight
        pfrec.matwidth      =  self.matwidth
        pfrec.hascron       =  false
        pfrec.runatstartup  =  true
 
        do
        {                            
            try pcam.motionrec += [pfrec.build()]
        } catch
        {
            print(error)
        }



        // MOTION

        var data:NSData!
        do
        {
            let m = try msg_save.build()
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
    
    func imageDownloaded(file : [String])
    {
        let camerastr:String = files[0]

        let cameraImage:UIImage = CVWrapper.processImageWithStrToCVMat(camerastr)
                        
        self.image.image = cameraImage
    }

    func simpleMessageReceived(message: Motion.Message_)
    { 

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

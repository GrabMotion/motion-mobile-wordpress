//
//  SetupViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/5/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse

class Device
{
    var user = User()
    var cameras = [Camera]()
   
    var joined = Bool()
    var running = Bool()

    var ipnumber                = String()
    var ippublic                = String()
    var macaddress              = String()
    var hostname                = String()
    var city                    = String()
    var country                 = String()
    var location                = String()
    var network_provider        = String()
    var uptime                  = String()
    var starttime               = String()
    var db_local                = Int()
    var model                   = String()
    var hardware                = String()
    var serial                  = String()
    var revision                = String()
    var disktotal               = Int() 
    var diskused                = Int() 
    var diskavailable           = Int() 
    var disk_percentage_used    = Int() 
    var temperature             = Int()

    var collapsed = Bool()
    
    init(){}

}

class Camera
{
    var cameranumber = Int()
    var cameraname = String()
    var recognizing = Bool()
    var thumbnail = UIImage()

    init(){}
}

class User
{   

    var clientnumber    = Int()
    var wp_userid       = Int()
    var wp_client_id    = Int()
    var wp_first_name   = String()
    var wp_last_name    = String()
    var location        = String()
    init(){}
}

protocol RemoteIpDelegate
{
    func getServerIp(info:String)
}

class SetupViewController:  UIViewController, 
RemoteIpDelegate, 
SocketProtocolDelegate
{

    var devices = [Device]()

    @IBOutlet weak var tableContainer: UIView!
    
    var serverUrl = String()
    
    var delegate:RemoteIpDelegate? = nil
    
    var networkaddrip = String()
    var localaddrip = String()
    var remoteServerIp = String()
    var remoteport:Int = Int(Motion.Message_.SocketType.UdpPort.rawValue)
     
    var timerUdp = NSTimer()
    var urlserver = String()
    var userdata = [String]()
    
    var deviceIp = String()
    
    var socket = Socket()
    
    var mainController:MainViewController?
    
    let defaults = NSUserDefaults.standardUserDefaults()

    var setupTableView : SetupCameraTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nip = self.getWiFiAddress()!
        localaddrip = nip
        var iparray = nip.componentsSeparatedByString(".")
        networkaddrip = iparray[0] + "." + iparray[1] + "." + iparray[2] + ".255"
        
        self.delegate = self
        self.socket.delegate = self

    }

    func getWiFiAddress() -> String? 
    {
    
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let interface = ptr.memory
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface.ifa_addr.memory.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    if let name = String.fromCString(interface.ifa_name) where name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var addr = interface.ifa_addr.memory
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                        address = String.fromCString(hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchDevices(sender: AnyObject)
    {
        SwiftSpinner.show("Searching for devices...")
        self.RunUPDServer()
        self.RunUDPClient()
    }
    
    func RunUDPClient()
    {
        let client:UDPClient = UDPClient(addr: self.localaddrip, port: remoteport)//19876)
        print("send MYAPP_TOKEN")
        client.send(str: "MYAPP_TOKEN")
        client.close()
    }
    
    
    func getServerIp(info: String)
    {
        timerUdp.invalidate()
        
        remoteServerIp = info
        print ("llega: " + info)
        SwiftSpinner.hide()
        
        //self.tableviewData.append(info)
        
        socket.deviceIp = remoteServerIp
        socket.setLocaladdrip(localaddrip)
        
        let message = Motion.Message_.Builder()
        message.setTypes(.Engage)
        message.setServerip(info)
        message.setPackagesize(socket.packagesize)
        
        socket.sendMessage(message)
        
    }
    
    func simpleMessageReceived(message: Motion.Message_)
    {
        
        switch message.types.hashValue
        {
            case Motion.Message_.ActionType.Engage.hashValue:
                self.engage(message)
            break
            
            case Motion.Message_.ActionType.GetImage.hashValue:
                self.getImage(message)
            break
        
            default:
                break
        }  
    }
    
    func engage(message: Motion.Message_)
    {

        var device = Device()

        let rdevices:[Motion.Message_.MotionDevice] = message.motiondevice

        for rdevice:Motion.Message_.MotionDevice in rdevices
        {
               device.ipnumber             = rdevice.ipnumber                
               device.ippublic             = rdevice.ippublic                
               device.macaddress           = rdevice.macaddress              
               device.hostname             = rdevice.hostname                
               device.city                 = rdevice.city                    
               device.country              = rdevice.country                 
               device.location             = rdevice.location                
               device.network_provider     = rdevice.networkProvider
               device.uptime               = rdevice.uptime                  
               device.starttime            = rdevice.starttime
               device.db_local             = Int(rdevice.dbLocal)
               device.model                = rdevice.model                   
               device.hardware             = rdevice.hardware                
               device.serial               = rdevice.serial                  
               device.revision             = rdevice.revision                
               device.disktotal            = Int(rdevice.disktotal)               
               device.diskused             = Int(rdevice.diskused)                
               device.diskavailable        = Int(rdevice.diskavailable)           
               device.disk_percentage_used = Int(rdevice.diskPercentageUsed)    
               device.temperature          = Int(rdevice.temperature)             
        }


        let ruser:[Motion.Message_.MotionUser] = message.motionuser

        if ruser.count > 0
        {
            device.joined = true
        } 

        let rcameras:[Motion.Message_.MotionCamera] = message.motioncamera
        
        var count = Int()

        if rcameras.count > 0
        {   

            for rcamera:Motion.Message_.MotionCamera in rcameras
            {

                let camera = Camera()
                camera.cameranumber = Int(rcamera.cameranumber)
                camera.cameraname   = rcamera.cameraname
                camera.recognizing  = rcamera.recognizing

                if camera.recognizing
                {
                    device.running = true
                }

                //let rnsdata = rcamera.thumbnail
                
                //Get length of [UInt8]
                //let length = rnsdata.length
                        
                //Convert NSData to [UInt8] array
                //var myArray = [UInt8](count: length, repeatedValue: 0)
                //rnsdata.getBytes(&myArray, length: length)
                        
                //Convert [UInt8] to NSData
                //let resultNSData = NSData(bytes: &myArray, length: length)
                        
                //Convert NSData to NSString
                //let resultNSString = NSString(data: resultNSData, encoding: NSUTF8StringEncoding)!

                /*let thubmnailstr:String = self.socket.files[count]

                print("___________________________________")
                print(thubmnailstr)

                let cameraImg64:String? = self.decodebase64(thubmnailstr)

                print("___________________________________")
                print(cameraImg64)

                if (cameraImg64?.characters.count != 0)
                {
                    let decodedData = NSData(base64EncodedString: cameraImg64!, options: NSDataBase64DecodingOptions(rawValue: 0))
                    
                    let decodedimage = UIImage(data: decodedData!)

                    camera.thumbnail = decodedimage!
                }
                device.cameras.append(camera)*/

                let thubmnailstr:String = self.socket.files[count]

                print(":::::::::::::::::::::::::::")
                print(thubmnailstr.characters.count)
                print(":::::::::::::::::::::::::::")
                
                if thubmnailstr.characters.count > 0
                {
                    //let decodedData:NSData = NSData(base64EncodedString: thubmnailstr, options: NSDataBase64DecodingOptions(rawValue: 0))
                    
                    //let decodedData = NSData(base64EncodedString: thubmnailstr, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) 

                    //let imageData = NSData(base64EncodedString: thubmnailstr, options: NSDataBase64EncodingOptions.allZeros)

                    //let decodedimage = UIImage(data: decodedData!)

                    //let decodedimage:UIImage = self.convertBase64ToImage(thubmnailstr)
                    
                    let decodedData = NSData(base64EncodedString: thubmnailstr, options: NSDataBase64DecodingOptions(rawValue: 0))
                    if let decodedImage = UIImage(data: decodedData!) 
                    {
                        camera.thumbnail = decodedImage
                    }

                    //if let decoded:Uiimage = decodedimage?
                    //{
                    //    camera.thumbnail = decodedimage
                    //}
                }
                device.cameras.append(camera)
                
                count++
            }
        }

        self.devices.append(device)

        self.setupTableView!.devices  = self.devices

        self.setupTableView.reload()
        
    }

    func convertBase64ToImage(base64String: String) -> UIImage {

        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)

        var decodedimage = UIImage(data: decodedData!)

        return decodedimage!

    }// end convertBase64ToImage

    public func decodebase64(str : String) -> String
    {

        let decodedData     = NSData(base64EncodedString: str, options:NSDataBase64DecodingOptions(rawValue: 0))
            let decodedString   = String(data: decodedData!, encoding: NSUTF8StringEncoding)
        return decodedString!
    }
    
    func getImage(message: Motion.Message_)
    {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
        if segue.identifier == "SegueSetupDeviceList"
        {   
            self.setupTableView = segue.destinationViewController as! SetupCameraTableViewController
        }
    }
    
    func RunUPDServer()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let server:UDPServer = UDPServer(addr:self.networkaddrip, port: self.remoteport)
            let run:Bool=true
            while run
            {
                var (data, remoteip, _) = server.recv(1024)
                print(data)
                if let d=data
                {
                    if let str=String(bytes: d, encoding: NSUTF8StringEncoding)
                    {
                        print(str)
                    }
                }
                print(remoteip)
                self.delegate?.getServerIp(remoteip)
                //server.close()
                sleep(3)
                break
            }
        })
        
    }
    
    func join(sender: UIButton)
    {
        let buttonTag = sender.tag
        
    }


}


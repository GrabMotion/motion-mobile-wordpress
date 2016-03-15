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
    var uuid_installation       = String()

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

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
        
        self.remoteServerIp = info
        print ("llega: " + info)
        SwiftSpinner.hide()
        
        self.appDelegate.localaddrip = localaddrip
              
        socket.deviceIp = info
        socket.setLocaladdrip(localaddrip)
        
        let message = Motion.Message_.Builder()
        message.types = Motion.Message_.ActionType.Engage
        message.serverip = info

        message.packagesize = socket.packagesize
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

        //let pfuser = Motion.Message_.MotionUser.Builder()
        //pfuser.setWpserverurl(wpserverurlbase64.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        //pfuser.setWpuser("dlskfjlfdsfsldsajfadsfasdfasdlkjsdflkasjdflkjaslkjdflkajsdflkjaslkdfjlksajdflkdfsdfsdfdssdfskdfjl".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        //pfuser.setWppassword("fglkfgdd__asdfasdlkfjdsf_DFA_SDAfjlk".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        //pfuser.setWpclientid(40)
        //pfuser.setWpclientmediaid(222)

       //pfuser.setWpServerUrl("gfdgdfsgsdgsfgsdfgsdfg") //wpserverurlbase64)
        //pfuser.setuiidinstallation("UIID") //uiidinstallation)
        //spfuser.setwpuserid(33) //_wp_userid_)
        /*pfuser.setWpClientId(_wp_client_id_)
        pfuser.setWpClientMediaid(_wp_client_mediaid_)
        pfuser.setUsername(_username)
        pfuser.setEmail(_email)
        pfuser.setFirstName(_first_name)
        pfuser.setLastName(_last_name)
        pfuser.setLocation("\(_location.latitude) \(_location.longitude)")
        pfuser.setUiidinstallation(uiidinstallation)
        pfuser.setClientnumber(_wp_userid_)

        do
        {                            
            try message.motionuser += [pfuser.build()]
        } catch
        {
            print(error)
        }*/

        socket.sendMessage(data)

       
        
        
       
        /*do
        {
            let message = try message.build()

            print("\(message)")

            print("\(message.data())")

        } catch
        {
            print(error)
        }*/

        //socket.sendMessage(message)
        
    }
    
    func simpleMessageReceived(message: Motion.Message_)
    {
        
        switch message.types.hashValue
        {
            case Motion.Message_.ActionType.Engage.hashValue: 
                self.engage(message)
            break
            case Motion.Message_.ActionType.ServerInfo.hashValue:
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
               device.serial               = 		rdevice.serial
               device.revision             = rdevice.revision                
               device.disktotal            = Int(rdevice.disktotal)               
               device.diskused             = Int(rdevice.diskused)                
               device.diskavailable        = Int(rdevice.diskavailable)           
               device.disk_percentage_used = Int(rdevice.diskPercentageUsed)    
               device.temperature          = Int(rdevice.temperature)  

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                {
                   let device = PFObject(className: "Device")

                   let uuid_raspberry_installation = NSUUID().UUIDString
                   device.setObject(uuid_raspberry_installation, forKey: "uuid_installation")

                   device.setObject(rdevice.ipnumber, forKey: "ipaddress")

                   device.setObject(rdevice.ippublic, forKey: "publicipaddress")

                   device.setObject(rdevice.hostname, forKey: "hostname")

                   device.setObject(rdevice.model, forKey: "model")

                   device.setObject(rdevice.location, forKey: "location")

                   device.saveInBackgroundWithBlock ({
                        (success: Bool, error: NSError?) -> Void in

                        let pfuser  = PFUser.currentUser()
                    
                        if pfuser != nil
                        {

                            let raspRel:PFRelation = pfuser!.relationForKey("device") as PFRelation
                            raspRel.addObject(device)

                            pfuser!.saveInBackgroundWithBlock
                            {
                                (success: Bool , error: NSError?) -> Void in
                                 
                                if success
                                {
                                    print("Device Stored.")                       
                                } else {
                                    print("Device Not Stored.") 
                                }
                            }
                        }
                    })   
                }
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

                if message.includethubmnails
                {

                    let thubmnailstr:String = self.socket.files[count]

                    if thubmnailstr.characters.count > 0
                    {
                              
                        let stitchedImage:UIImage = CVWrapper.processImageWithStrToCVMat(thubmnailstr)
                        
                        camera.thumbnail = stitchedImage
                    
                    }

                }
                
                device.cameras.append(camera)
                
                count++
            }
        }

        self.devices.append(device)

        self.setupTableView!.devices  = self.devices

        self.appDelegate.deviceIp = self.remoteServerIp

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


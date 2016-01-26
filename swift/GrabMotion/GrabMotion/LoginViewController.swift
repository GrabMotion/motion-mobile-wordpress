//
//  ViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/22/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ProtocolBuffers
import Alamofire


protocol RemoteIpDelegate
{
    func getServerIp(info:String)
}


class LoginViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, RemoteIpDelegate
{
    

    var tableviewData = [String]()
    
    @IBOutlet weak var deviceTableView: UITableView!
    
    var delegate:RemoteIpDelegate? = nil
    
    var networkaddrip = String()
    var localaddrip = String()
    var remoteServerIp = String()
    var remoteport:Int = Int(Motion.Message_.SocketType.UdpPort.rawValue)
    
    var timerUdp = NSTimer()
    var urlserver = String()
    var userdata = [String]()
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()

    var serverrunning = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //UPD Fetch Ip Network Broadcast.
        let nip = self.getWiFiAddress()!
        localaddrip = nip
        var iparray = nip.componentsSeparatedByString(".")
        networkaddrip = iparray[0] + "." + iparray[1] + "." + iparray[2] + ".255"
        
        delegate = self
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    
        
        if (PFUser.currentUser() == nil) {
            
            self.logInViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .DismissButton]
            
            
            //let logInLogoTitle = UILabel()
            //logInLogoTitle.text = "GrabMotion"
            
            //self.logInViewController.logInView!.logo = logInLogoTitle
            
            self.logInViewController.delegate = self
            
            //let SignUpLogoTitle = UILabel()
            //SignUpLogoTitle.text = "GrabMotion"
            
            let logoView = UIImageView(image: UIImage(named:"grabmotion_logo.png"))
            
            self.logInViewController.logInView!.logo  = logoView

            
            //self.signUpViewController.signUpView!.logo = SignUpLogoTitle
            
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            
            self.presentViewController(self.logInViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
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

    
    @IBAction func setCustomUrlServer(sender: AnyObject)
    {
        
    }
    
    @IBAction func searchDevices(sender: AnyObject) {
        
        SwiftSpinner.show("Searching for devices...")
        
        //if !self.serverrunning
        //{
            self.RunUPDServer()
        //}
        
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
        
        self.tableviewData.append(info)
        
        dispatch_async(dispatch_get_main_queue())
        {
            self.deviceTableView.reloadData()
        }
    
        urlserver = "http://" + info + ":5556/"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.tableviewData.isEmpty
        {
            return 0
        } else
        {
            return self.tableviewData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
            
       let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DeviceTableViewCell
    
        cell.textLabel?.text = self.tableviewData[indexPath.row]
        
        cell.joinButton.tag = indexPath.row
        
        cell.joinButton.addTarget(self, action: "joinButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
                
                
                
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
          }
    
    
    
    func RunUPDServer()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let server:UDPServer = UDPServer(addr:self.networkaddrip, port: self.remoteport)
            let run:Bool=true
            while run
            {
                self.serverrunning = true
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
        
    
    
}


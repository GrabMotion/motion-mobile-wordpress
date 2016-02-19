//
//  SetupViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/5/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse

protocol RemoteIpDelegate
{
    func getServerIp(info:String)
}

class SetupViewController:  UIViewController, 
RemoteIpDelegate, 
UITableViewDataSource, 
UITableViewDelegate, 
SocketProtocolDelegate
{

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
    
    var tableviewData = [String]()
    
    var socket = Socket()
    
    var mainController:MainViewController?

    @IBOutlet weak var deviceTableView: UITableView!

    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nip = self.getWiFiAddress()!
        localaddrip = nip
        var iparray = nip.componentsSeparatedByString(".")
        networkaddrip = iparray[0] + "." + iparray[1] + "." + iparray[2] + ".255"
        
        self.delegate = self
        self.socket.delegate = self

        self.deviceTableView.layer.cornerRadius=5
        
        self.deviceTableView.delegate = self

    }

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
        
        self.tableviewData.append(info)
        
        socket.deviceIp = remoteServerIp
        socket.setLocaladdrip(localaddrip)
        
        let message = Motion.Message_.Builder()
        message.setTypes(.Engage)
        
        socket.sendMessage(message)
        
        //dispatch_async(dispatch_get_main_queue())
        //{
        //        self.deviceTableView.reloadData()
        //}
        
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
        
    }
    
    func getImage(message: Motion.Message_)
    {
        
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.tableviewData.isEmpty
        {
            return 0
        } else
        {
            let count = self.tableviewData.count
            print(count)
            return count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        //let cell:DeviceTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DeviceTableViewCell
        
        let genericCell = self.deviceTableView.cellForRowAtIndexPath(indexPath)
        
        if indexPath.section == 0
        {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DeviceTableViewCell
            if cell == nil
            {
                print("null")
            }
            
            cell!.textLabel?.text = self.tableviewData[indexPath.row]
            
            cell!.joinButton.addTarget(self, action: "join:", forControlEvents: .TouchUpInside)
            
            return cell!
        
        }
        
        //cell!.joinButton.hidden = false
        
        //cell!.joinButton.tag = indexPath.row
        
        return genericCell!
    }

   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label : UILabel = UILabel()
        
        if section == 0
        {
            label.text = "Devices found"
        
        } else if section == 1
        {
            label.text = "Advanced"
        }
        return label
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

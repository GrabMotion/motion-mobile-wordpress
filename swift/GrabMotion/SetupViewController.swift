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
    var ipaddress = String()

    var devicestarttime = String()
    var joined = Bool()

    var running = Bool()
    
    init(){}

}

class Camera
{
    var cameranumber = Int()
    var cameraname = String()
    var recognizing = Bool()
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
UITableViewDataSource, 
UITableViewDelegate, 
SocketProtocolDelegate
{

    // ACCORDION TABLE VIEW ///

    /// The data source for the parent cell.
    var topItems = [String]()
    
    /// The data source for the child cells.
    var subItems = [[String]]()
    
    /// The position for the current items expanded.
    var currentItemsExpanded = [Int]()
    
    /// The originals positions of each parent cell.
    var actualPositions: [Int]!
    
    /// The number of elements in the data source
    var total = 0
    
    /// The identifier for the parent cells.
    let parentCellIdentifier = "ParentCell"
     
    /// The identifier for the child cells.
    let childCellIdentifier = "ChildCell"

    //////////////////////////////

    var devices = [Device]()

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
        
        //self.tableviewData.append(info)
        
        socket.deviceIp = remoteServerIp
        socket.setLocaladdrip(localaddrip)
        
        let message = Motion.Message_.Builder()
        message.setTypes(.Engage)
        message.setServerip(info)
        
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
        device.ipaddress = message.serverip

        let user:[Motion.Message_.MotionUser] = message.motionuser

        if user.count > 0
        {
            device.joined = true
        } 

        let rcameras:[Motion.Message_.MotionCamera] = message.motioncamera

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

                device.cameras.append(camera)

            }
        }

        self.devices.append(device)

        //let user = User()
        
       dispatch_async(dispatch_get_main_queue())
       {
            self.deviceTableView.reloadData()
       }

    }
    
    func getImage(message: Motion.Message_)
    {
        
    }
   
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }*/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.devices.count == 0
        {
            return 0
        } else
        {
            let count = self.devices.count
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

            if self.devices[indexPath.row].joined
            {
                cell!.statusLabel?.text = "Joined"
                
                if self.devices[indexPath.row].running
                {
                   cell!.statusImage.image = UIImage(named: "camerarunning")    
                } else 
                {
                    cell!.statusImage.image = UIImage(named: "cameraon")    
                }

            } else 
            {
                cell!.statusLabel?.text = "Unjoined"

                cell!.statusImage.image = UIImage(named: "camerano")    

            }
            
            cell!.textLabel?.text = self.devices[indexPath.row].ipaddress
            
            
            return cell!
        
        }
    
        return genericCell!
    }

   /*func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label : UILabel = UILabel()
        
        if section == 0
        {
            label.text = "Devices found"
        
        } else if section == 1
        {
            label.text = "Advanced"
        }
        return label
    }*/
    
     /**
     Set the initial data for test the table view.
     
     - parameter parents: The number of parents cells
     - parameter childs:  Then maximun number of child cells per parent.
     */
    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
        
        // Set the total of cells initially.
        self.total = parents
        
        // Init the array with all the values in -1
        self.actualPositions = [Int](count: parents, repeatedValue: -1)
        
        // Create an array with the element "Item index".
        self.topItems = (0..<parents).enumerate().map { "Item \($0.0 + 1)"}
        
        // Create the array of childs using a random number between 0..childs+1 for each parent.
        self.subItems = (0..<parents).map({ _ -> [String] in
            
            // generate the random number between 0...childs
            let random = Int(arc4random_uniform(UInt32(childs + 1))) + 1
            
            // create the array for each cell
            return (0..<random).enumerate().map {"Subitem \($0.index)"}
        })
    }
    
    /**
     Expand the cell at the index specified.
     
     - parameter index: The index of the cell to expand.
     */
    private func expandItemAtIndex(index : Int) {
        
        // find the parent cell of the cell with index specified.
        let val = self.findParent(index)
        
        // the data of the subitems for the specific parent cell.
        let currentSubItems = self.subItems[val]
        
        // position to start to insert rows.
        var insertPos = index + 1
        
        // create an array of NSIndexPath with the selected positions
        let indexPaths = (0..<currentSubItems.count).map { _ in NSIndexPath(forRow: insertPos++, inSection: 0) }
        
        // insert the new rows
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total += self.subItems[val].count
    }
    
    /**
     Collapse the cell at the index specified.
     
     - parameter index: The index of the cell to collapse
     */
    private func collapseSubItemsAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        
        // find the parent cell of the cell with index specified.
        let parent = self.findParent(index)
        
        // create an array of NSIndexPath with the selected positions
        for i in index + 1...index + self.subItems[parent].count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        // remove the expanded cells
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total -= self.subItems[parent].count
    }
    
    /**
     Send the execution to collapse or expand the cell with parent and index specified.
     
     - parameter parent: The parent of the cell.
     - parameter index:  The index of the cell.
     */
    private func setExpandeOrCollapsedStateforCell(parent: Int, index: Int) {
        
        // if the cell is expanded
        if let value = self.currentItemsExpanded.indexOf(parent) {
            
            self.collapseSubItemsAtIndex(index)
            self.actualPositions[parent] = -1
            
            // remove the parent from the expanded list
            self.currentItemsExpanded.removeAtIndex(value)
            
            for i in parent + 1..<self.topItems.count {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] -= self.subItems[parent].count
                }
            }
        }
        else {
            
            self.expandItemAtIndex(index)
            self.actualPositions[parent] = index
            
            for i in parent + 1..<self.topItems.count {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] += self.subItems[parent].count
                }
            }
            
            // add the parent for the expanded list
            self.currentItemsExpanded.append(parent)
        }
    }
    
    /**
     Check if the cell at indexPath is a child or not.
     
     - parameter indexPath: The NSIndexPath for the cell
     
     - returns: True if it's a child cell, otherwise false.
     */
    private func isChildCell(indexPath: NSIndexPath) -> Bool {
        
        // find the parent cell of the cell with index specified.
        let parent = self.findParent(indexPath.row)
        
        // check if it's expanded or not
        let idx = self.currentItemsExpanded.indexOf(parent)
        
        return idx != nil && indexPath.row != self.actualPositions[parent]
    }
    
    /**
     Find the index of the parent cell for the index of a cell.
     
     - parameter index: The index of the cell to find the parent
     
     - returns: The index of parent cell.
     */
    private func findParent(index : Int) -> Int {
        
        var parent = 0
        var i = 0
        
        while (true) {
            
            if (i >= index) {
                return parent
            }
            
            // if it's expanded the cell
            if let _ = self.currentItemsExpanded.indexOf(parent) {
                
                // sum its childs and continue
                i += self.subItems[parent].count + 1
                
                if (i > index) {
                    return parent
                }
            }
            else {
                i += 1
            }
            parent += 1
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

extension AccordionMenuTableViewController 
{
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int 
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return self.total
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 
    {
        
        var cell : UITableViewCell!
        let parent = self.findParent(indexPath.row)

        if self.isChildCell(indexPath) {
            cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = self.subItems[parent][indexPath.row - self.actualPositions[parent] - 1]
            cell.backgroundColor = UIColor.greenColor()
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = self.topItems[parent]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) 
    {
        
        guard !self.isChildCell(indexPath) else {
            NSLog("A child was tapped!!!");
            return
        }
        
        self.tableView.beginUpdates()
        
        let parent = self.findParent(indexPath.row)
        self.setExpandeOrCollapsedStateforCell(parent, index: indexPath.row)
        
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat 
    {
        //return self.isChildCell(indexPath) ? 44.0 : 64.0
        return self.isChildCell(indexPath) ? 60.0 : 75.0
    }

}
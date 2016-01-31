//
//  TerminalViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/27/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Parse
import ProtocolBuffers

class TerminalViewController: UIViewController {

    var socket = Socket()
    
    @IBOutlet weak var camerasTable: UITableView!
    
    @IBOutlet weak var addJob: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.currentUser()
        user!.fetchInBackgroundWithBlock({ (currentUser: PFObject?, error: NSError?) -> Void in
            
            if let user = currentUser as? PFUser {
                
                var email = user.email
                var pass = user.password
                var sessionToken = user.sessionToken
                
                
                
            }
        })
        
        print(socket.deviceIp)
        print(socket.localaddrip)
        
        let message = Motion.Message_.Builder()
        message.setTypes(Motion.Message_.ActionType.Engage)
        message.setServerip(socket.localaddrip)
        socket.sendMessage(message)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

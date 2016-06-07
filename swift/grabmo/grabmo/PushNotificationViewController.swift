//
//  PushNotificationViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 2/18/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Push
{
    var camera            = String()
    var recognition       = String()
    var time              = String()
    var idmat             = Int()
    var thumbnail         = UIImage()

    init(){}
}



class PushNotificationViewController: UITableViewController 
{
    
    var mainController:MainViewController?

    var pushes = [Push]()    

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning()        
    }   

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    

}

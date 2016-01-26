//
//  DeviceTableViewCell.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/25/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("llega")
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("llega")
        // Configure the view for the selected state
    }

}

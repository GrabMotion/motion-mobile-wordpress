//
//  NotificationTableViewCell.swift
//  GrabMotion
//
//  Created by Jose Vigil on 5/23/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var picture: UIImageView!
   
    
    @IBOutlet weak var rectime: UILabel!
    
    @IBOutlet weak var recognition: UILabel!
    
    @IBOutlet weak var camera: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

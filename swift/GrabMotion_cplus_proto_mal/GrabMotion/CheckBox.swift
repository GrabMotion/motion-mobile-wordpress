//
//  CheckBox.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/25/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "checked_checkbox")
    let unCheckedImage = UIImage(named: "unchecked_checkbox")
    
    //bool propety
    var isChecked:Bool = false{
        didSet{
            if isChecked == true{
                self.setImage(checkedImage, forState: .Normal)
            }else{
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    
    
    func buttonClicked(sender:UIButton) {
        if(sender == self){
            if isChecked == true{
                isChecked = false
            }else{
                isChecked = true
            }
        }
    }
    
}
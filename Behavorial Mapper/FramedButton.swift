//
//  LegendButton.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import QuartzCore

class FramedButton: UIButton {

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        //layer.borderWidth = 1
        //layer.borderColor = Style.textPrimary.cgColor
        self.backgroundColor = Style.clickablePrimary
        
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

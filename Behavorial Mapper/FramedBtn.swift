//
//  LegendButton.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import QuartzCore

class FramedBtn: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        layer.borderWidth = 1
        layer.borderColor = Style.textPrimary.cgColor
        
        self.setTitleColor(Style.textPrimary, for: .normal)
        self.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
    }
}

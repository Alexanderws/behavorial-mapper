//
//  LegendButton.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class LegendButton: UIButton {

    
    let gradient = CAGradientLayer()
    gradient.frame =  CGRect(origin: CGPointZero, size: self.myButton.frame.size)
    gradient.colors = [UIColor.blueColor().CGColor, UIColor.greenColor().CGColor]
    
    let shape = CAShapeLayer()
    shape.lineWidth = 2
    shape.path = UIBezierPath(rect: self.myButton.bounds).CGPath
    shape.strokeColor = UIColor.blackColor().CGColor
    shape.fillColor = UIColor.clearColor().CGColor
    gradient.mask = shape
    
    self.myButton.layer.addSublayer(gradient)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        layer.addSublayer(gradient)
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

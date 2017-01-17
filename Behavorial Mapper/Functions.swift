//
//  Functions.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit


func getWhiteBackground(width: CGFloat, height: CGFloat) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
    UIColor.white.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

extension UIColor {
    class func fromHex(hex: Int) -> UIColor {
        let red: Int = (hex >> 16) & 0xFF
        let green: Int = (hex >> 8) & 0xFF
        let blue: Int = hex & 0xFF
        return UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
}
    
    

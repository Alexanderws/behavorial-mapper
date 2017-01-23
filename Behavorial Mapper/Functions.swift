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
        let red: CGFloat = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue: CGFloat = CGFloat(hex & 0xFF) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

func containsText(object: Any) -> Bool {
    return !((object as AnyObject).text!.isEmpty)
}

func dateFormat(date: Date)-> String {
    let df = DateFormatter()
    df.dateFormat = "dd MMM yyyy"
    return df.string(from: date)
}

func timeFormat(date: Date)-> String {
    let df = DateFormatter()
    df.dateFormat = "hh:mm:ss"
    return df.string(from: date)
}

func bearingPoint(point0: CGPoint, point1: CGPoint) -> CGPoint {
    let newPoint = CGPoint(x:(point1.x - point0.x), y:(point0.y - point1.y))
    return newPoint
}

func pointToDegrees(x: CGFloat, y: CGFloat) -> CGFloat {
    let bearingRadian = atan2f(Float(y), Float(x))
    return CGFloat(bearingRadian) * (180 / CGFloat(M_PI))
}

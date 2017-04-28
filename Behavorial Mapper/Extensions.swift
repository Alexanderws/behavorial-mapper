//
//  Extensions.swift
//  Behavorial Mapper
//
//  Created by Alexander on 15/04/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func mappingVC() -> MappingVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MappingVC") as? MappingVC
    }
    
    class func mappingMenuVC() -> MappingMenuVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MappingMenuVC") as? MappingMenuVC
    }
    
    class func createProjectVC() -> CreateProjectVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CreateProjectVC") as? CreateProjectVC
    }
    
    class func startVC() -> StartVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "StartVC") as? StartVC
    }
}

/**
 Creates a UIColor from a standard 0xRRGGBB color representation.
 
 - parameters:
 - hex: Color in 0xRRGGBB hex representation.
 
 - important:
 Does not support alpha values.
 */


extension UIColor {
    class func fromHex(hex: Int) -> UIColor {
        let red: CGFloat = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue: CGFloat = CGFloat(hex & 0xFF) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIView {
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 3.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}

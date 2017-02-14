//
//  Style.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!]) 
        }
    }
}

struct Style {
    static let clickablePrimary = UIColor.fromHex(hex: 0x000000) // Black
    static let clickableSecondary = UIColor()
    static let clickableDestructive = UIColor()
    static let clickableBkg = UIColor.fromHex(hex: 0x000000) // Black
    static let backgroundPrimary = UIColor.fromHex(hex: 0x303030) // Dark grey
    static let backgroundSecondary = UIColor.fromHex(hex: 0x45474A) // Medium grey
    static let backgroundTextField = UIColor.fromHex(hex: 0x636567) // Medium-light grey
    static let backgroundTitleBar = UIColor.fromHex(hex: 0x31081F) // DeepWine
    static let backgroundTitleBarSecondary = UIColor.fromHex(hex: 0x723D46) // WoodRed
    static let textPrimary = UIColor.fromHex(hex: 0xFFFFFF) // White
    static let textSecondary = UIColor.fromHex(hex: 0x000000) // Black
}


/*
 DarkTeal = 0x485665
 DeepWine = 0x31081F
 BrightPinkPurple = 0x7C606B
 WoodRed = 0x723D46
 PurpleSky = 0xD6E3F8
 Medium-light grey 0x636567
*/

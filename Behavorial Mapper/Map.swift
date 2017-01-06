//
//  Map.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Map {
    
    private var _locations: [Location]!
    private var _entries: [Entry]!
    private var _background: UIImage!
    
    var locations: [Location] {
        get {
            return _locations
        } set {
            _locations = newValue
        }
    }
    
    var entries: [Entry] {
        get {
            return _entries
        } set {
            _entries = newValue
        }
    }
    
    var background: UIImage {
        get {
            return _background
        } set {
            _background = newValue
        }
    }
    
    init(background: UIImage) {
        self._background = background
        self._entries = [Entry]()
        self._locations = [Location]()
    }
}

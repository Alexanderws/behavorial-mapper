//
//  Legend.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Legend: CSVSerializable {
    
    private var _name: String!
    private var _icon: Int!

    
    var name: String {
        get {
            return _name
        } set {
            self._name = newValue
        }
    }
    
    var icon: Int {
        get {
            return _icon
        } set {
            self._icon = newValue
        }
    }
    
    
    init(name: String, icon: Int) {
        self._name = name
        self._icon = icon
    }
    
}

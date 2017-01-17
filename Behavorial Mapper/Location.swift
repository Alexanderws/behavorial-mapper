//
//  Location.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Location: CSVSerializable {
    
    private var _name: String!
    private var _xCor: Int!
    private var _yCor: Int!
    
    var name: String {
        get {
            return _name
        } set {
            self._name = newValue
        }
    }
    
    var xCor: Int {
        get {
            return _xCor
        } set {
            self._xCor = newValue
        }
    }
    
    var yCor: Int {
        get {
            return _yCor
        } set {
            self._yCor = newValue
        }
    }
 
    init (name: String, xCor: Int, yCor: Int) {
        self._name = name
        self._xCor = xCor
        self._yCor = yCor
    }
    
}

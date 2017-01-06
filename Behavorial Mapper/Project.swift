//
//  Project.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Project {
    
    private var _name: String!
    private var _created: Date!
    private var _note: String!
    private var _legend: [Legend]!
    private var _map: Map!
    
    var note: String {
        get {
            return _note
        } set {
            _note = note
        }
    }
    
    var name: String {
        get {
            return _name
        } set {
            _name = newValue
        }
    }
    
    init (name: String, map: Map, legend: [Legend]) {
        self._name = name
        self._created = Date()
        self._map = map
        self._legend = legend
        self._note = ""
    }
    
    init (name: String, map: Map, legend: [Legend], note: String) {
        self._name = name
        self._created = Date()
        self._map = map
        self._legend = legend
        self._note = note
    }
    
}

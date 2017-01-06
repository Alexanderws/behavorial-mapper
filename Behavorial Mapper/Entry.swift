//
//  Entry.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Entry {
    
    private var _time: Date!
    private var _start: Location!
    private var _end: Location!
    private var _legend: Legend!
    private var _note: Note?
    
    var time: Date {
        get {
            return _time
        } set {
            _time = newValue
        }
    }
    
    var start: Location {
        get {
            return _start
        } set {
            _start = newValue
        }
    }
    
    var end: Location {
        get {
            return _end
        } set {
            _end = newValue
        }
    }
    
    var legend: Legend {
        get {
            return _legend
        } set {
            _legend = newValue
        }
    }
    
    var note: String {
        get {
            return _note
        } set {
            _note = newValue
        }
    }
    
    init(start: Location, end: Location, legend: Legend) {
        self._time = Date()
        self._start = start
        self._end = end
        self._legend = legend
    }
    
}

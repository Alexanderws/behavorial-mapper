//
//  Entry.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Entry: CSVSerializable {
    
    private var _time: Date!
    private var _start: CGPoint!
    private var _angleInDegrees: CGFloat!
    private var _legend: Legend!
    private var _note: String!
    private var _tagId: Int!
    
    var time: Date {
        get {
            return _time
        } set {
            _time = newValue
        }
    }
    
    var start: CGPoint {
        get {
            return _start
        } set {
            _start = newValue
        }
    }
    
    var angleInDegrees: CGFloat {
        get{
            return _angleInDegrees
        } set {
            _angleInDegrees = newValue
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
    
    var tagId: Int {
        get {
            return _tagId
        }
    }
    
    init(start: CGPoint, angleInDegrees: CGFloat, legend: Legend, tagId: Int) {
        self._time = Date()
        self._start = start
        self._angleInDegrees = angleInDegrees
        self._legend = legend
        self._note = ""
        self._tagId = tagId
    }
    
}

//
//  Entry.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Entry: JSONSerializable, CSVSerializable {
    
    private var _time: Date!
    private var _position: CGPoint!
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
    
    var position: CGPoint {
        get {
            return _position
        } set {
            _position = newValue
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
    
    init(position: CGPoint, angleInDegrees: CGFloat, legend: Legend, tagId: Int) {
        self._time = Date()
        self._position = position
        self._angleInDegrees = angleInDegrees
        self._legend = legend
        self._note = ""
        self._tagId = tagId
    }
    
    init?(json: [String: Any]) {
        guard let date = json["_time"],
            let position = json["_position"],
            let angleInDegrees = json["_angleInDegrees"],
            let legend = json["_legend"],
            let note = json["_note"],
            let tagId = json["_tagId"]
            else {
                return nil
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self._time = df.date(from: date as! String)
        
        let positionArr = position as! [CGFloat]
        self._position = CGPoint.init(x: positionArr[0], y: positionArr[1])
        self._angleInDegrees = angleInDegrees as! CGFloat
        self._legend = Legend.init(json: legend as! [String: Any])
        self._note = note as! String
        self._tagId = tagId as! Int
    }
}

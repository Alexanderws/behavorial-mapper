//
//  Project.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit


protocol ProjectDelegate {
    func entryDeleted(tagId: Int)
}

class Project: JSONSerializable {
    
    private var _name: String!
    private var _created: Date!
    private var _note: String!
    private var _legend: [Legend]!
    private var _entries: [Entry]!
    private var _background: UIImage!
    
    var projectDelegate: ProjectDelegate?
    
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
    
    var legend: [Legend]! {
        get {
            return _legend
        } set {
            _legend = newValue
        }
    }

    init (name: String, background: UIImage, legend: [Legend], note: String) {
        self._name = name
        self._created = Date()
        self._background = background
        self._legend = legend
        self._note = note
        self._entries = [Entry]()
    }
    
    func addEntry(legend: Legend, angleInDegrees: CGFloat, position: CGPoint, tagId: Int) {
        _entries.append(Entry(start: position, angleInDegrees: angleInDegrees, legend: legend, tagId: tagId))
    }
    
    func removeEntry(index: Int){
        let entry = entries[index]
        print("removeEntry: index = \(index)")
        entries.remove(at: index)
        print("removeEntry: tagId = \(entry.tagId)")
        projectDelegate?.entryDeleted(tagId: entry.tagId)
    }
    
}

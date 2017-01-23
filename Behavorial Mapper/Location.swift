//
//  Location.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Location: JSONSerializable, CSVSerializable {
    
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
    
    init?(json: [String: Any]) {
        guard let name = json["_name"],
            let xCor = json["_xCor"],
            let yCor = json["_yCor"]
            else {
                return nil
        }
        self._name = name as! String
        self._xCor = xCor as! Int
        self._yCor = yCor as! Int
    }
    
    init?(jsonStr: String) {
        if let json = try? JSONSerialization.jsonObject(with: jsonStr.data(using: .utf8)!, options: []) {
            guard let name = (json as! [String: Any])["_name"],
                let xCor = (json as! [String: Any])["_xCor"],
                let yCor = (json as! [String: Any])["_yCor"]
                else {
                    return nil
            }
            self._name = name as! String
            self._xCor = xCor as! Int
            self._yCor = yCor as! Int
        } else {
            return nil
        }
    }
}

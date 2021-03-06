//
//  Legend.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Legend: JSONSerializable, CSVSerializable {
    
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
    
    init?(json: [String: Any]) {
        guard let name = json["_name"],
            let icon = json["_icon"]
            else {
                return nil
        }
        self._name = name as! String
        self._icon = icon as! Int
    }
}

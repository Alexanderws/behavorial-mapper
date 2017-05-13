//
//  JSONSerializable.swift
//  Behavorial Mapper
//
//  Created by Espen on 23/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

protocol JSONRepresentable {
    var JSONRepresentation: Any { get }
}

protocol JSONSerializable: JSONRepresentable {}

extension JSONSerializable{
    var JSONRepresentation: Any {
        var jsonDict = [String: Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            /*case let value as Location:
                jsonDict[label] = value.JSONRepresentation*/
                
            case let value as Legend:
                jsonDict[label] = value.JSONRepresentation
                
            case let value as Entry:
                jsonDict[label] = value.JSONRepresentation
                
            case let value as Date:
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                df.timeZone = TimeZone(abbreviation: "CET")
                jsonDict[label] = df.string(from: value)
                
            case let value as CGPoint:
                jsonDict[label] = [(value.x), (value.y)]
                
            case let value as Dictionary<String, Any>:
                jsonDict[label] = value as Any
                
            case let value as Array<Any>:
                if let val = value as? [JSONSerializable] {
                    jsonDict[label] = val.map({ $0.JSONRepresentation as Any }) as Any
                } else {
                    jsonDict[label] = value as Any
                }
                
            case let value:
                if label == "projectDelegate" {
                    continue
                }
                jsonDict[label] = value as Any
            }
        }
        return jsonDict
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            print("Invalid JSON Representation")
            print(representation)
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

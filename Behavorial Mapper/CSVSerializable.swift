//
//  CSVSerializable.swift
//  Behavorial Mapper
//
//  Created by Espen on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

protocol CSVSerializable {
    var _csvHeader: String { get }
    var _csvBody: String { get }
    
    func csvHeader() -> String
    func csvBody() -> String
}

extension CSVSerializable {
    var _csvHeader: String {
        var header = String()
        
        switch self {
        case is Entry:
            header += "time;start;andgleInDegrees;note;"
        case is  Location:
            header += "name;xCor;yCor;"
        case is Legend:
            header += "name;icon;"
        default:
            header += ""
        }
        
        for case let (_?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as Location:
                for case let (inner?, _) in Mirror(reflecting: value).children {
                    header += inner.substring(from: inner.index(after: inner.startIndex)) + ";"
                }
            case let value as Legend:
                for case let (inner?, _) in Mirror(reflecting: value).children {
                    header += inner.substring(from: inner.index(after: inner.startIndex)) + ";"
                }
            case let value as Entry:
                for case let (inner?, _) in Mirror(reflecting: value).children {
                    header += inner.substring(from: inner.index(after: inner.startIndex)) + ";"
                }
            default:
                header += ""
            }
        }
        
        return header.substring(to: header.index(before: header.endIndex))
    }
    
    var _csvBody: String {
        var body = String()
        
        switch self {
        case let main as Location:
            body += main.name + ";" + String(main.xCor) + ";" + String(main.yCor) + ";"
        case let main as Legend:
            body += main.name + ";" + String(main.icon) + ";"
        case let main as Entry:
            body += String(describing: main.time) + ";"
            body += String(describing: main.start) + ";"
            body += String(describing: main.angleInDegrees) + ";"
            body += main.note + ";"
        default:
            body += ";"
        }
        
        for case let (_, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as Location:
                body += value.name + ";" + String(value.xCor) + ";" + String(value.yCor) + ";"
            case let value as Legend:
                body += value.name + ";" + String(value.icon) + ";"
            case let value as Entry:
                body += String(describing: value.time) + ";"
                body += value.note + ";"
            default:
                body += ""
            }
        }
        return body.substring(to: body.index(before: body.endIndex))
    }
    
    func csvHeader() -> String {
        return self._csvHeader
    }
    
    func csvBody() -> String {
        return self._csvBody
    }
}

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
            header += "\(CSV_TIME);\(CSV_COORDINATES);\(CSV_ANGLE_IN_DEGREES);\(CSV_ENTRY_NOTE);"
        case is  Location:
            header += "\(CSV_LOCATION_NAME);\(CSV_X_COORDINATE);\(CSV_Y_COORDINATE);"
        case is Legend:
            header += "\(CSV_ENTRY_NAME);\(CSV_ENTRY_ICON);"
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
            body += DateFormatter.localizedString(from: main.time,dateStyle: .short,timeStyle: .short) + ";"
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

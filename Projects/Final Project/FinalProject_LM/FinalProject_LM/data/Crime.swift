//
//  Crime.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 5/25/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation

struct Crime: Codable {
    var identifier: String?
    var policeArea: String
    var crimeType: String
    var crimeCode: String
    var date: String
    var hour: String
    var bookmarked: Bool?
    let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case policeArea = "area_policiaca"
        case crimeType = "delitos_code"
        case crimeCode = "delito"
        case date = "fecha"
        case hour = "hora"
        case bookmarked
        case location
    }
    
    public init() {
        identifier = ""
        policeArea = ""
        crimeType = ""
        crimeCode = ""
        date = ""
        hour = ""
        bookmarked = nil
        location = nil
    }
}

struct Location: Codable {
    let type: String
    let coordinates: [Double]
}

extension Crime {
    
    var areCrimeFilledOut: Bool {
        return !policeArea.isEmpty && !crimeType.isEmpty
            && !crimeCode.isEmpty && !date.isEmpty && !hour.isEmpty
    }
    
    mutating func updateCrime(_ type: CrimeRowCellType, _ value:
        String) -> Crime {
        
        switch type {
        case .crimeCode:
            crimeCode = value
        case .crimeType:
            crimeType = value
        case .date:
            date = value
        case .hour:
            hour = value
        case .policeArea:
            policeArea = value
        }
        
        return self
    }
}

extension Crime: Equatable {
    static func ==(lhs: Crime, rhs: Crime) -> Bool {
        
        guard lhs.date == rhs.date else {
            return false
        }
        
        guard lhs.hour == rhs.hour else {
            return false
        }
        
        guard lhs.policeArea == rhs.policeArea else {
            return false
        }
        
        return true
    }
}

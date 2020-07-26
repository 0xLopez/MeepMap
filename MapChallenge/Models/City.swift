//
//  City.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Foundation

enum City: String, CaseIterable, Identifiable, Comparable {
    case lisbon
    case madrid
    case valencia
    
    var id: String {
        rawValue
    }
    
    static func < (lhs: City, rhs: City) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

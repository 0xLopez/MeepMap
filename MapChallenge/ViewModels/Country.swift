//
//  Country.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 23/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import CoreLocation
import SwiftUI

class Country {
    let cities: [City]
    
    init(cities: [City] = City.allCases.sorted()) {
        self.cities = cities
    }
}

extension City {
    var pathName: String {
        switch self {
        case .lisbon:
            return "lisboa"
        default:
            return rawValue
        }
    }
    
    var center: CLLocationCoordinate2D {
        switch self {
        case .lisbon:
            return .init(latitude: 38.737895, longitude: -9.15365)
        case .madrid:
            return .init(latitude: 40.4239, longitude: -3.68889)
        case .valencia:
            return .init(latitude: 39.469872, longitude: -0.373538)
        }
    }
    
    var color: Color {
        switch self {
        case .lisbon:
            return Color(red: 123/255, green: 157/255, blue: 237/255)
        case .madrid:
            return Color(red: 1, green: 113/255, blue: 113/255)
        case .valencia:
            return Color(red: 1, green: 189/255, blue: 105/255)
        }
    }
}

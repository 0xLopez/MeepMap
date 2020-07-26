//
//  Resource.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 21/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Foundation

struct Resource: Codable, Equatable {
    let id: String
    let x: Double
    let y: Double
    let companyZoneId: Int
}

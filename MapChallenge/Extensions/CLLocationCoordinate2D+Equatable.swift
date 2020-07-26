//
//  CLLocationCoordinate2D+Equatable.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

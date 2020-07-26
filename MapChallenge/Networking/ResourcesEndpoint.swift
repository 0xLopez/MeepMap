//
//  ResourcesEndpoint.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import CoreLocation
import Foundation

struct ResourcesArea {
    let lowerLeftCoordinate: CLLocationCoordinate2D
    let upperRightCoordinate: CLLocationCoordinate2D
}

struct ResourcesEndpoint {
    let city: City
    let area: ResourcesArea
    
    private var lowerLeftLatitude: CLLocationDegrees {
        area.lowerLeftCoordinate.latitude
    }
    private var lowerLeftLongitude: CLLocationDegrees {
        area.lowerLeftCoordinate.longitude
    }
    private var upperRightLatitude: CLLocationDegrees {
        area.upperRightCoordinate.latitude
    }
    private var upperRightLongitude: CLLocationDegrees {
        area.upperRightCoordinate.longitude
    }
}

extension ResourcesEndpoint: URLEndpoint {
    var path: String {
        return "/routers/\(city.pathName)/resources"
    }
    var method: HTTPMethod {
        .get
    }
    var parameters: [URLParameter] {
        [
            .init(queryItem: "lowerLeftLatLon", value: "\(lowerLeftLatitude),\(lowerLeftLongitude)"),
            .init(queryItem: "upperRightLatLon", value: "\(upperRightLatitude),\(upperRightLongitude)"),
        ]
    }
}

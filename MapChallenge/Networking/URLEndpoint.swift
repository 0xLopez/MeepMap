//
//  URLEndpoint.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Foundation

protocol URLEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLParameter] { get }
    var timeout: TimeInterval { get }
}

extension URLEndpoint {
    var parameters: [URLParameter] {
        return []
    }
    var timeout: TimeInterval {
        return 15
    }
}

struct URLParameter: Equatable {
    let queryItem: String
    let value: String
}

enum HTTPMethod: String {
    case get = "GET"
}

//
//  URL+Parameters.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 25/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Foundation

extension URL {
    mutating func append(_ parameters: [URLParameter]) {
        guard !parameters.isEmpty, var urlComponents = URLComponents(string: absoluteString) else {
            return
        }
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = []
        }
        parameters.forEach { urlComponents.queryItems?.append(URLQueryItem(name: $0.queryItem, value: $0.value)) }
        self = urlComponents.url ?? absoluteURL
    }
}

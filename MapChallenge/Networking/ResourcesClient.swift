//
//  ResourcesClient.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

protocol ResourcesService {
    func getResources(for city: City, area: ResourcesArea) -> AnyPublisher<[Resource], URLError>
}

class ResourcesClient: NetworkClient {
    static let baseUrlString = "https://apidev.meep.me/tripplan/api/v1"
    static let shared = ResourcesClient(baseUrlString: ResourcesClient.baseUrlString)
}

extension ResourcesClient: ResourcesService {
    func getResources(for city: City, area: ResourcesArea) -> AnyPublisher<[Resource], URLError> {
        let endpoint = ResourcesEndpoint(city: city, area: area)
        return sendRequest(for: endpoint)
    }
}

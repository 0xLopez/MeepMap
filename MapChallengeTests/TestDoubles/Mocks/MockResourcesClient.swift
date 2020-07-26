//
//  MockResourcesClient.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import Foundation
@testable import MapChallenge

class MockResourcesClient: ResourcesService {
    
    private(set) var publisher = PassthroughSubject<[Resource], URLError>()
    
    func getResources(for city: City, area: ResourcesArea) -> AnyPublisher<[Resource], URLError> {
        return publisher.eraseToAnyPublisher()
    }
}

//
//  MockURLSession.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import Foundation
@testable import MapChallenge

class MockURLSession: URLSessionProtocol {
    
    private(set) var taskPublisher = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        taskPublisher.eraseToAnyPublisher()
    }
}

//
//  URLSessionProtocol.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let publisher: DataTaskPublisher = dataTaskPublisher(for: request)
        return publisher.eraseToAnyPublisher()
    }
}

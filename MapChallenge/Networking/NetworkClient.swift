//
//  NetworkClient.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 21/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import Foundation
import CoreLocation

class NetworkClient {
    
    let baseUrl: URL
    let session: URLSessionProtocol
    
    init(baseUrlString: String, session: URLSessionProtocol = URLSession.shared) {
        guard let baseUrl = URL(string: baseUrlString) else {
            preconditionFailure("The url is not valid")
        }
        self.baseUrl = baseUrl
        self.session = session
    }
    
    func sendRequest<T: Codable>(for endpoint: URLEndpoint) -> AnyPublisher<T, URLError> {
        sendDataRequest(for: endpoint)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in
                URLError(.cannotDecodeRawData)
            }
            .eraseToAnyPublisher()
    }
    
    private func sendDataRequest(for endpoint: URLEndpoint) -> AnyPublisher<Data, URLError> {
        session.dataTaskPublisher(for: getRequest(for: endpoint))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    private func getRequest(for endpoint: URLEndpoint) -> URLRequest {
        var url = baseUrl.appendingPathComponent(endpoint.path)
        url.append(endpoint.parameters)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.timeoutInterval = endpoint.timeout
        return urlRequest
    }
}

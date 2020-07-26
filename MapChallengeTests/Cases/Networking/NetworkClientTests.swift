//
//  NetworkClientTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 21/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
@testable import MapChallenge
import XCTest

class NetworkClientTests: XCTestCase {
    
    var sut: NetworkClient!
    var session: MockURLSession!
    let baseUrlString = ResourcesClient.baseUrlString
    let fakeEndpoint = FakeEndpoint()
    let fakeObject = FakeCodable(id: 1)
    var url: URL {
        guard let baseUrl = URL(string: baseUrlString) else {
            preconditionFailure("The url is not valid")
        }
        var url = baseUrl.appendingPathComponent(fakeEndpoint.path)
        url.append(fakeEndpoint.parameters)
        return url
    }
    var anyCancellable: AnyCancellable?

    override func setUpWithError() throws {
        try super.setUpWithError()
        session = MockURLSession()
        sut = NetworkClient(baseUrlString: baseUrlString, session: session)
    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        anyCancellable = nil
        try super.tearDownWithError()
    }
    
    // MARK: - When
    private func whenPublished(data: Data? = nil, statusCode: Int = 200, error: URLError? = nil) {
        let publisher = session.taskPublisher
        if let error = error {
            publisher.send(completion: .failure(error))
            return
        }
        let data = data ?? Data()
        guard let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
            return
        }
        publisher.send((data: data, response: response))
        publisher.send(completion: .finished)
    }
    
    private func whenSendDataRequest(completion: @escaping (Subscribers.Completion<URLError>) -> Void, receiveValue: @escaping ((Data, URLResponse)) -> Void) {
        sendRequest()
        anyCancellable = session.taskPublisher.sink(receiveCompletion: completion, receiveValue: receiveValue)
    }
    
    private func whenSendCodableRequest<T: Codable>(completion: @escaping (Subscribers.Completion<URLError>) -> Void, receiveValue: @escaping (T) -> Void) {
        let publisher: AnyPublisher<T, URLError> = sut.sendRequest(for: fakeEndpoint)
        anyCancellable = publisher.sink(receiveCompletion: completion, receiveValue: receiveValue)
    }
    
    @discardableResult
    private func sendRequest() -> AnyPublisher<FakeCodable, URLError> {
        sut.sendRequest(for: fakeEndpoint)
    }
    
    // MARK: - Init
    func testInit_setsBaseUrl() throws {
        // given
        let baseUrl = try XCTUnwrap(URL(string: baseUrlString))
        
        // then
        XCTAssertEqual(sut.baseUrl, baseUrl)
    }
    
    // MARK: - Send request
    func testSendRequest_whenErrorPublished_receivesError() {
        // given
        let expectedError = URLError(.badServerResponse)
        var receivedError: URLError?
        
        // when
        whenSendDataRequest(completion: { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }, receiveValue: { _  in })
        whenPublished(error: expectedError)
        
        // then
        XCTAssertEqual(expectedError, receivedError)
    }
    
    func testSendRequest_whenDataPublished_receivesData() throws {
        // given
        let expectedData = try XCTUnwrap(JSONEncoder().encode(fakeObject))
        var receivedData: Data?
        
        // when
        whenSendDataRequest(completion: { _ in }, receiveValue: { (data, _) in
            receivedData = data
        })
        whenPublished(data: expectedData)
        
        // then
        XCTAssertEqual(expectedData, receivedData)
    }
    
    func testSendRequest_whenDataPublished_receivesObject() throws {
        // given
        let expectedObject = fakeObject
        let data = try XCTUnwrap(JSONEncoder().encode(expectedObject))
        var receivedObject: FakeCodable?
        let expectation = self.expectation(description: "Data wasn't decoded")
        
        // when
        whenSendCodableRequest(completion: { _ in }, receiveValue: { (object: FakeCodable) in
            receivedObject = object
            expectation.fulfill()
        })
        whenPublished(data: data)
        
        // then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertEqual(expectedObject, receivedObject)
        }
    }
    
    func testSendRequest_whenWrongDataPublished_receivesDecodeError() throws {
        // given
        let data = "wrong data".data(using: .utf8) ?? Data()
        let expectation = self.expectation(description: "Decoding error wasn't received")
        let expectedError = URLError(.cannotDecodeRawData)
        var receivedError: URLError?
        
        // when
        whenSendCodableRequest(completion: { result in
            if case let .failure(error) = result {
                receivedError = error
                expectation.fulfill()
            }
        }, receiveValue: { (object: FakeCodable) in })
        whenPublished(data: data)
        
        // then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertEqual(expectedError, receivedError)
        }
    }
}

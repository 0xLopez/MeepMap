//
//  URLEndpointTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

@testable import MapChallenge
import XCTest

class URLEndpointTests: XCTestCase {
    
    var sut: URLEndpoint!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FakeEndpoint()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testURLEndpoint_declaresPath() {
        _ = sut.path
    }
    
    func testURLEndpoint_declaresMethod() {
        _ = sut.method
    }
    
    func testURLEndpoint_declaresParameters() {
        _ = sut.parameters
    }
    
    func testURLEndpoint_declaresTimeout() {
        _ = sut.timeout
    }
}

//
//  URLTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 25/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

@testable import MapChallenge
import XCTest

class URLTests: XCTestCase {
    
    var sut: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = URL(string: ResourcesClient.baseUrlString)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testUrl_whenEmptyParameters_returns() {
        // given
        let noParameters: [URLParameter] = []
        var url = sut
        
        // when
        url?.append(noParameters)
        
        // then
        XCTAssertEqual(sut, url)
    }
    
    func testUrl_whenParametersPassed_addsQueryItems() throws {
        // given
        let parameters: [URLParameter] = [
            .init(queryItem: "first", value: "1"),
            .init(queryItem: "second", value: "2")
        ]
        let expectedQueryItems = "first=1&second=2"
        
        // when
        sut.append(parameters)
        
        // then
        let queryItems = try XCTUnwrap(sut.query)
        XCTAssertEqual(queryItems, expectedQueryItems)
    }
}

//
//  ResourceTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 25/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

@testable import MapChallenge
import XCTest

class ResourceTests: XCTestCase {
    
    func testResource_conformsToCodable() {
        // given
        let sut = Resource(id: "1", x: 0, y: 0, companyZoneId: 1)
        
        // then
        XCTAssertTrue((sut as Any) is Codable)
    }
}

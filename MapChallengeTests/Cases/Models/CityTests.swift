//
//  CityTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 25/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

@testable import MapChallenge
import XCTest

class CityTests: XCTestCase {
    
    var sut: City!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .lisbon
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testCity_conformsToIdentifiable() {
        XCTAssertEqual(sut.id, sut.rawValue)
    }
    
    func testCity_conformsToComparable() {
        // given
        let city: City = .valencia
        
        // then
        XCTAssertLessThan(sut, city)
    }
}

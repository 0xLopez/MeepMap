//
//  CountryTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import CoreLocation
@testable import MapChallenge
import XCTest

class CountryTests: XCTestCase {
    
    // MARK: - Verify
    private func verifyCenter(of city: City, expectedCenter: CLLocationCoordinate2D, line: UInt = #line) {
        XCTAssertEqual(city.center, expectedCenter, line: line)
    }
    
    private func verifyPath(of city: City, expectedPath: String, line: UInt = #line) {
        XCTAssertEqual(city.pathName, expectedPath, line: line)
    }
    
    // MARK: - Init
    func testInit_setsCities() {
        // given
        let cities: [City] = [.lisbon, .valencia]
        
        // when
        let sut = Country(cities: cities)
        
        // then
        XCTAssertEqual(sut.cities, cities)
    }
    
    // MARK: - Cities
    func testCenter_whenValenciaCity() {
        // given
        let expectedCenter = CLLocationCoordinate2D(latitude: 39.469872, longitude: -0.373538)
        
        // then
        verifyCenter(of: .valencia, expectedCenter: expectedCenter)
    }
    
    func testCenter_whenMadridCity() {
        // given
        let expectedCenter = CLLocationCoordinate2D(latitude: 40.4239, longitude: -3.68889)
        
        // then
        verifyCenter(of: .madrid, expectedCenter: expectedCenter)
    }
    
    func testCenter_whenLisbonCity() {
        // given
        let expectedCenter = CLLocationCoordinate2D(latitude: 38.737895, longitude: -9.15365)
        
        // then
        verifyCenter(of: .lisbon, expectedCenter: expectedCenter)
    }
    
    func testPath_whenValenciaCity() {
        // given
        let expectedPath = "valencia"
        
        // then
        verifyPath(of: .valencia, expectedPath: expectedPath)
    }
    
    func testPath_whenMadridCity() {
        // given
        let expectedPath = "madrid"
        
        // then
        verifyPath(of: .madrid, expectedPath: expectedPath)
    }
    
    func testPath_whenLisbonCity() {
        // given
        let expectedPath = "lisboa"
        
        // then
        verifyPath(of: .lisbon, expectedPath: expectedPath)
    }
}

//
//  CLLocationCoordinate2DTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import CoreLocation
import XCTest

class CLLocationCoordinate2DTests: XCTestCase {
    
    func testCoordinate_conformsToEquatable() {
        // given
        let sut = CLLocationCoordinate2D(latitude: 0.5, longitude: 0.4)
        
        // then
        XCTAssertEqual(sut, sut)
    }
}

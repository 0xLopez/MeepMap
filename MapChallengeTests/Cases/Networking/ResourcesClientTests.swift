//
//  ResourcesClientTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

@testable import MapChallenge
import XCTest

class ResourcesClientTests: XCTestCase {
    var sut: ResourcesClient!
    let baseUrlString = ResourcesClient.baseUrlString

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ResourcesClient(baseUrlString: baseUrlString)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testShared_setsBaseUrl() throws {
        // given
        let baseUrl = try XCTUnwrap(URL(string: baseUrlString))
        
        // then
        XCTAssertEqual(ResourcesClient.shared.baseUrl, baseUrl)
    }
    
    func testClient_conformsToResourcesService() {
        XCTAssertTrue((sut as AnyObject) is ResourcesService)
    }
    
    func testService_declaresGetResources() {
        // given
        let service = sut as ResourcesService
        let resourcesArea = ResourcesArea(
            lowerLeftCoordinate: .init(latitude: 0, longitude: 0),
            upperRightCoordinate: .init(latitude: 0, longitude: 0)
        )
        
        // then
        _ = service.getResources(for: .valencia, area: resourcesArea)
    }
}

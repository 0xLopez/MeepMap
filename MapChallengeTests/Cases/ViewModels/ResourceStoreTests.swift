//
//  ResourceStoreTests.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import GoogleMaps
@testable import MapChallenge
import XCTest

class ResourceStoreTests: XCTestCase {
    
    var sut: ResourceStore!
    var mockClusterManager: MockClusterManager!
    var mockClient: MockResourcesClient!
    var anyCancellable: AnyCancellable!
    let resources: [Resource] = [
        .init(id: "1", x: 1, y: 1, companyZoneId: 1),
        .init(id: "2", x: 2, y: 2, companyZoneId: 2)
    ]

    override func setUpWithError() throws {
        whenSUTSet()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockClusterManager = nil
        mockClient = nil
        anyCancellable = nil
        try super.tearDownWithError()
    }
    
    // MARK: - When
    private func whenSUTSet(from city: City = .lisbon) {
        mockClient = MockResourcesClient()
        sut = ResourceStore(city: city, client: mockClient)
    }
    
    private func whenClusterManagerSet() {
        mockClusterManager = MockClusterManager.getInstance()
        sut.setClusterManager(mockClusterManager)
    }
    
    private func whenMarkerAdded() {
        // given
        let marker = GMSMarker()
        
        // when
        whenClusterManagerSet()
        sut.addMarker(marker)
    }
    
    private func whenResourcesFetched(resources: [Resource]? = nil, completion: Subscribers.Completion<URLError>? = nil, errorHandler: URLErrorHandler? = nil) {
        // given
        let resourcesArea = ResourcesArea(lowerLeftCoordinate: .init(), upperRightCoordinate: .init())
        
        // when
        sut.fetchResources(for: resourcesArea, errorHandler: errorHandler)
        if let resources = resources {
            mockClient.publisher.send(resources)
        }
        if let completion = completion {
            mockClient.publisher.send(completion: completion)
        }
    }
    
    // MARK: - Initialization
    func testInit_setsCity() {
        // given
        let city: City = .valencia
        
        // when
        whenSUTSet(from: city)
        
        // then
        XCTAssertEqual(sut.city, city)
    }
    
    func testInit_selectedMarker_isNotSet() {
        XCTAssertNil(sut.selectedMarker)
    }
    
    func testInit_clusterManager_isNotSet() {
        XCTAssertNil(sut.selectedMarker)
    }
    
    func testInit_isLoading_isFalse() {
        XCTAssertFalse(sut.isLoading)
    }
    
    func testInit_resourcesColors_isEmpty() {
        XCTAssertTrue(sut.resourceColors.isEmpty)
    }
    
    // MARK: - Markers
    func testSetSelectedMarker_setsMarker() {
        // given
        let marker = GMSMarker()
        
        // when
        sut.setSelectedMarker(marker)
        
        // then
        XCTAssertEqual(sut.selectedMarker, marker)
    }
    
    func testSetClusterManager_setsClusterManager() {
        // when
        whenClusterManagerSet()
        
        // then
        XCTAssertEqual(sut.clusterManager, mockClusterManager)
    }
    
    func testCluster_clusters() {
        // when
        whenClusterManagerSet()
        sut.cluster()
        
        // then
        XCTAssertTrue(mockClusterManager.calledCluster)
    }
    
    func testAddMarker_addsAMarker() {
        // when
        whenMarkerAdded()
        
        // then
        XCTAssertEqual(mockClusterManager.items.count, 1)
    }
    
    func testClearMarkers_clearsMarkers() {
        // when
        whenMarkerAdded()
        sut.clearMarkers()
        
        // then
        XCTAssertTrue(mockClusterManager.items.isEmpty)
    }
    
    // MARK: - Fetch Resources
    func testStore_whenFetchResources_setsAnyCancellable() throws {
        // when
        whenResourcesFetched()
        
        // then
        XCTAssertNotNil(sut.anyCancellable)
    }
    
    func testStore_whenFetchResources_isLoading() throws {
        // when
        whenResourcesFetched()
        
        // then
        XCTAssertTrue(sut.isLoading)
    }
    
    func testClient_whenResourcesPublished_setsResources() {
        // when
        whenResourcesFetched(resources: resources, completion: .finished)
        
        // then
        XCTAssertEqual(self.sut.resources, resources)
    }
    
    func testClient_whenPublisherFinished_isNotLoading() {
        // when
        whenResourcesFetched(completion: .finished)
        
        // then
        XCTAssertFalse(sut.isLoading)
    }
    
    func testClient_whenPublisherFails_sendsError() {
        // given
        let expectedError = URLError(.badURL)
        var receivedError: URLError?
        
        // when
        whenResourcesFetched(completion: .failure(expectedError)) { error in
            receivedError = error
        }
        
        // then
        XCTAssertEqual(expectedError, receivedError)
    }
    
    // MARK: - Map
    func testCenterCoordinate_returnsCityCenter() {
        // given
        let city: City = .valencia
        let expectedCenter = city.center
        
        // when
        whenSUTSet(from: city)
        
        // then
        XCTAssertEqual(sut.centerCoordinate, expectedCenter)
    }
    
    func testMarkers_createsAMarkerPerResource() {
        // when
        whenResourcesFetched(resources: resources)
        
        // then
        XCTAssertEqual(resources.count, sut.markers.count)
    }
    
    func testMarkers_setsResourceColors() {
        // when
        whenResourcesFetched(resources: resources)
        _ = sut.markers
        
        // then
        XCTAssertEqual(sut.resourceColors.count, resources.count)
    }
    
    func testResourceColors_whenSameCompanyZoneId_returnsSameColor() {
        // given
        let resource1 = Resource(id: "1", x: 1, y: 1, companyZoneId: 2)
        let resource2 = Resource(id: "2", x: 2, y: 2, companyZoneId: 2)
        
        // when
        whenResourcesFetched(resources: [resource1, resource2])
        _ = sut.markers
        
        // then
        XCTAssertEqual(sut.resourceColors.count, 1)
    }
}

//
//  MockClusterManager.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import GoogleMapsUtils
import Foundation

class MockClusterManager: GMUClusterManager {
    
    private(set) var items: [GMUClusterItem] = []
    private(set) var calledCluster = false
    
    static func getInstance() -> MockClusterManager {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let mapView = GMSMapView()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        return .init(map: mapView, algorithm: algorithm, renderer: renderer)
    }
    
    override func clearItems() {
        items.removeAll()
    }
    
    override func add(_ item: GMUClusterItem) {
        items.append(item)
    }
    
    override func cluster() {
        calledCluster = true
    }
}

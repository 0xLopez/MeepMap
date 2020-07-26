//
//  ResourceStore.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 21/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import Combine
import CoreLocation
import GoogleMapsUtils
import SwiftUI

class ResourceStore: ObservableObject {
    @Published private(set) var resources: [Resource] = []
    @Published private(set) var shouldShowDecodingError = false
    @Published private(set) var isLoading = false
    
    let city: City
    private let resourcesClient: ResourcesService
    private(set) var anyCancellable: AnyCancellable?
    private(set) var resourceColors: [Int: UIColor] = [:]
    private(set) var clusterManager: GMUClusterManager?
    private(set) var selectedMarker: GMSMarker?
    
    init(city: City, client: ResourcesService = ResourcesClient.shared) {
        self.city = city
        resourcesClient = client
    }
    
    func fetchResources(for area: ResourcesArea, errorHandler: URLErrorHandler? = nil) {
        isLoading = true
        anyCancellable = resourcesClient.getResources(for: city, area: area)
            .sink(receiveCompletion: { result in
                self.isLoading = false
                if case let .failure(error) = result {
                    errorHandler?(error)
                }
            }, receiveValue: { resources in
                self.resources = resources
            })
    }
}

// MARK: - Map
extension ResourceStore {
    var centerCoordinate: CLLocationCoordinate2D {
        city.center
    }
    private var markerColors: Set<UIColor> {
        [.orange, .yellow, .blue, .red, .brown, .purple, .black, .gray]
    }
    private var colorAlpha: CGFloat {
        0.5
    }
    var markers: [GMSMarker] {
        resources.map {
            let position = CLLocationCoordinate2D(latitude: $0.y, longitude: $0.x)
            let marker = GMSMarker(position: position)
            marker.title = "Company Zone: \($0.companyZoneId)"
            marker.snippet = "ID: \($0.id)"
            let color = getColor(for: $0.companyZoneId)
            marker.icon = GMSMarker.markerImage(with: color)
            return marker
        }
    }
    
    private func getColor(for resourceNumber: Int) -> UIColor {
        if let color = resourceColors[resourceNumber] {
            return color
        }
        let colors = Set(markerColors.map { $0.withAlphaComponent(colorAlpha) })
        let availableColors = colors.subtracting(Set(resourceColors.values))
        let selectedColor = (availableColors.randomElement() ?? colors.randomElement() ?? .orange)
        resourceColors[resourceNumber] = selectedColor
        return selectedColor
    }
    
    func setClusterManager(_ clusterManager: GMUClusterManager) {
        self.clusterManager = clusterManager
    }
    
    func cluster() {
        clusterManager?.cluster()
    }
    
    func addMarker(_ marker: GMSMarker) {
        clusterManager?.add(marker)
    }
    
    func clearMarkers() {
        clusterManager?.clearItems()
    }
    
    func setSelectedMarker(_ marker: GMSMarker?) {
        selectedMarker = marker
    }
}

//
//  MapView.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import GoogleMaps
import GoogleMapsUtils
import SwiftUI

typealias URLErrorHandler = (URLError) -> Void

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var resourceStore: ResourceStore
    var errorHandler: URLErrorHandler
    private let cameraZoom: Float = 16
    private let clusteringZoom: Float = 14.5
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        setupMap(mapView, context: context)
        let clusterManager = getClusterManager(mapView: mapView, context: context)
        resourceStore.setClusterManager(clusterManager)
        return mapView
    }
    
    private func setupMap(_ mapView: GMSMapView, context: Context) {
        mapView.camera = GMSCameraPosition(target: resourceStore.centerCoordinate, zoom: cameraZoom)
        mapView.settings.compassButton = true
        mapView.delegate = context.coordinator
    }
    
    private func getClusterManager(mapView: GMSMapView, context: Context) -> GMUClusterManager {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        let clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(nil, mapDelegate: context.coordinator)
        return clusterManager
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        resourceStore.clearMarkers()
        addMarkers(to: mapView)
        resourceStore.cluster()
    }
    
    private func addMarkers(to mapView: GMSMapView) {
        let needsClustering = mapView.camera.zoom < clusteringZoom
        if needsClustering {
            resourceStore.markers.forEach { resourceStore.addMarker($0) }
        } else {
            resourceStore.markers.forEach {
                $0.map = mapView
                if $0.position == resourceStore.selectedMarker?.position {
                    mapView.selectedMarker = $0
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(resourceStore: resourceStore, errorHandler: errorHandler)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        
        private var errorHandler: URLErrorHandler
        private let resourceStore: ResourceStore
        
        init(resourceStore: ResourceStore, errorHandler: @escaping URLErrorHandler) {
            self.resourceStore = resourceStore
            self.errorHandler = errorHandler
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            let visibleRegion = mapView.projection.visibleRegion()
            let lowerLeft = CLLocationCoordinate2D(
                latitude: min(visibleRegion.nearLeft.latitude, visibleRegion.nearRight.latitude),
                longitude: min(visibleRegion.nearLeft.longitude, visibleRegion.farLeft.longitude)
            )
            let upperRight = CLLocationCoordinate2D(
                latitude: max(visibleRegion.farLeft.latitude, visibleRegion.farRight.latitude),
                longitude: max(visibleRegion.nearRight.longitude, visibleRegion.farRight.longitude)
            )
            let resourcesArea = ResourcesArea(lowerLeftCoordinate: lowerLeft, upperRightCoordinate: upperRight)
            resourceStore.fetchResources(for: resourcesArea, errorHandler: errorHandler)
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            mapView.animate(toLocation: marker.position)
            if let _ = marker.userData as? GMUCluster {
                mapView.animate(toZoom: mapView.camera.zoom + 1)
                return true
            }
            resourceStore.setSelectedMarker(marker)
            return false
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            resourceStore.setSelectedMarker(nil)
        }
        
        func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
            resourceStore.setSelectedMarker(nil)
            mapView.selectedMarker = nil
        }
    }
}

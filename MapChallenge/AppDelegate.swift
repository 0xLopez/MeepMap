//
//  AppDelegate.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 21/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import GoogleMaps
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let mapsAPIKey = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupGoogleMaps()
        return true
    }
    
    private func setupGoogleMaps() {
        guard !mapsAPIKey.isEmpty else {
            preconditionFailure("Please provide a valid API Key using mapsAPIKey")
        }
        GMSServices.provideAPIKey(mapsAPIKey)
    }
}

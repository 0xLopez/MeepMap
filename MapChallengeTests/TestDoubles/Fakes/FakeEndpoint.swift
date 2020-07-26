//
//  FakeEndpoint.swift
//  MapChallengeTests
//
//  Created by Juan López Bosch on 25/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

@testable import MapChallenge
import Foundation

struct FakeEndpoint: URLEndpoint {
    let path = "fakePath"
    let method: HTTPMethod = .get
}

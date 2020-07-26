//
//  ActivityIndicator.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 24/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  
    let style : UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ activityIndicator: UIActivityIndicatorView, context: Context) {
        activityIndicator.startAnimating()
    }
}

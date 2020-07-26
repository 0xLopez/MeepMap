//
//  CityView.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 23/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import SwiftUI

struct CityView: View {
    @ObservedObject var resourceStore: ResourceStore
    @State var showAlert = false
    @State var errorMessage = ""
    
    var body: some View {
        MapView() { error in
            self.errorMessage = error.localizedDescription
            self.showAlert = true
        }
        .environmentObject(resourceStore)
        .navigationBarTitle(Text(resourceStore.city.rawValue.capitalized), displayMode: .inline)
        .navigationBarItems(trailing: loadingView)
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorMessage))
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if resourceStore.isLoading {
            ActivityIndicator(style: .medium)
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(resourceStore: .init(city: .lisbon))
    }
}

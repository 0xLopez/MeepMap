//
//  CityChooserView.swift
//  MapChallenge
//
//  Created by Juan López Bosch on 22/07/2020.
//  Copyright © 2020 Juan López. All rights reserved.
//

import SwiftUI

struct CityChooserView: View {
    
    let country = Country()
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(country.cities, id: \.self) { city in
                    NavigationLink(destination: CityView(resourceStore: .init(city: city))) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(city.color)
                            Text(city.rawValue.capitalized)
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: 100)
                    }
                }
                Spacer()
            }
            .padding(.vertical)
            .navigationBarTitle(.init("Select a City"))
        }
    }
}

struct CityChooserView_Previews: PreviewProvider {
    static var previews: some View {
        CityChooserView()
    }
}

//
//  NavBarView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 19/10/2025.
//

import SwiftUI
import SwiftData

struct NavBarView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    var body: some View {
        VStack{
            TabView(selection: $vm.selectedTab) {
                CurrentWeatherView()
                    .tabItem { Label("Now", systemImage: "sun.max.fill") }
                    .tag(0)
                
                ForecastView()
                    .tabItem { Label("Forecast", systemImage: "calendar") }
                    .tag(1)
                
                MapView()
                    .tabItem { Label("Map", systemImage: "map") }
                    .tag(2)
                
                VisitedPlacesView()
                    .tabItem { Label("Saved", systemImage: "globe") }
                    .tag(3)
            }
        }.ignoresSafeArea(.keyboard, edges: .all)
        
        
    }
}


#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    NavBarView()
        .environmentObject(vm)
}


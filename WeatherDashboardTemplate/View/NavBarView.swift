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
        
            TabView(selection: $vm.selectedTab) {
                CurrentWeatherView()
                    .background(Color.clear)
                    .tabItem { Label("Now", systemImage: "sun.max.fill") }
                    .tag(0)

                ForecastView()
                    .background(Color.clear)
                    .tabItem { Label("Forecast", systemImage: "calendar") }
                    .tag(1)

                MapView()
                    .background(Color.clear)
                    .tabItem { Label("Map", systemImage: "map") }
                    .tag(2)

                VisitedPlacesView()
                    .background(Color.clear)
                    .tabItem { Label("Saved", systemImage: "globe") }
                    .tag(3)
            }
            .background(Color.clear)
            // iOS 16+: make the tab bar transparent
            .toolbarBackground(.hidden, for: .tabBar)
        
    }
}


#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    NavBarView()
        .environmentObject(vm)
}

//#Preview("Full Dashboard") {
//    // 👇 This creates a mock ModelContext using your in-memory preview container
//    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
//
//    // 👇 This displays *all* your tab content at once
//    NavBarView()
//        .environmentObject(vm)
//}
//

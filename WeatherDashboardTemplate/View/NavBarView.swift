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
            // Reference from Grok
            /* Add swipe option to tabs
             .gesture(
                 DragGesture()
                     .onEnded { value in
                         let threshold: CGFloat = 50
                         // Only trigger tab change on primarily horizontal swipes
                         if abs(value.translation.width) > abs(value.translation.height) &&
                            abs(value.translation.width) > threshold {
                             if value.translation.width > 0 {
                                 // Swipe right → previous tab
                                 withAnimation {
                                     vm.selectedTab = max(vm.selectedTab - 1, 0)
                                 }
                             } else {
                                 // Swipe left → next tab
                                 withAnimation {
                                     vm.selectedTab = min(vm.selectedTab + 1, 3) // adjust max tab count
                                 }
                             }
                         }
                         // If swipe is mostly vertical or too small → do nothing (allows scrolling)
                     }
             )
             .simultaneousGesture(
                 DragGesture() // This is optional – helps ensure compatibility
             )
             */
        
        // End of reference code from Grok
        
        
        
    }
}


#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    NavBarView()
        .environmentObject(vm)
}


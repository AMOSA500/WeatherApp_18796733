//
//  WeatherDashboardTemplateApp.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

@main
struct WeatherDashboardTemplateApp: App {
    
    // code to set configure ViewModel and ModelContainer
    @StateObject private var vm: MainAppViewModel
    @State private var isActive = false
    private let container: ModelContainer
    init() {
        
        //  Define schema for all models
        let schema = Schema([Place.self, AnnotationModel.self])
        
        //  Persistent (on-disk) configuration
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])
        
        //  Create main model context
        let context = ModelContext(container)
        _vm = StateObject(wrappedValue: MainAppViewModel(context: context))
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                NavBarView()
                    .environmentObject(vm)
                //  Attach the same persistent container (not a new one!)
                    .modelContainer(container)
            } else {
                ZStack {
                    // SplashView() - My alternative to launch screen
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("Loading…")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onAppear {
                    // Sets the 3-second delay
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
                
        }
    }
    
}

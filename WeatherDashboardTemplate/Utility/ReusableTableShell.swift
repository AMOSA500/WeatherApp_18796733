//
//  ReusableTableShell.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 16/11/2025.
//

import SwiftUI

struct ReusableTableShell<Content: View>: View {
    // This will host the tab bar, search bar, gradient, and loading overlay.
    @EnvironmentObject var vm: MainAppViewModel
    let content: Content
    init (@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color.blue.opacity(0.5), Color.pink.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 🔍 Search Bar
                HStack {
                    TextField("Enter location", text: $vm.query)
                        .padding(0)
                        .submitLabel(.search)
                        .onSubmit { vm.submitQuery() }
                    
                    Button {
                        vm.submitQuery()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4, y: 2)
                .padding(.horizontal)
                .padding(.vertical, 20)
                   
                // Content from navbar view
                content
            }
            
        }
        
        .overlay {
            if vm.isLoading {
                ProgressView("Loading…")
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .alert(item: $vm.appError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

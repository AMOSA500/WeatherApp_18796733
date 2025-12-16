//
//  ReusableSearchBar.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 16/11/2025.
//

import SwiftUI

struct ReusableSearchBar: ViewModifier {
    // This will host the tab bar, search bar, gradient, and loading overlay.
    @EnvironmentObject var vm: MainAppViewModel
    
    
    func body(content: Content) -> some View {
        ZStack{
            LinearGradient(
                colors: [Color.blue.opacity(0.5), Color.pink.opacity(0.2)],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            ).ignoresSafeArea()
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 🔍 Search Bar
                HStack {
                    TextField("Enter location", text: $vm.query)
                        .padding(.bottom,  0)
                        .submitLabel(.search)
                        .onSubmit { Task { try await vm.search() } }
                    
                    Button {
                        Task { try await vm.search() }
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
                
                Divider()
                
                // Content from any view appears here
                content.background(Color.clear)
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

extension View {
    func reusableSearchBar() -> some View {
        self.modifier(ReusableSearchBar())
    }
}


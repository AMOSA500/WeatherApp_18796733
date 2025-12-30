//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Map Display
                Map(position: $vm.mapRegion) {
                    ForEach(vm.pois) { poi in
                        Marker(poi.name,
                               coordinate: CLLocationCoordinate2D(latitude: poi.latitude,
                                                                  longitude: poi.longitude))
                    }
                }
                .frame(height: 250)
                
                // Text detail
                HStack(spacing: 0) {
                    Text("Top 5 Tourist attractions in ")
                        .font(.footnote)
                    Text("\(vm.activePlaceName)")
                        .bold()
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.3))
                .padding(.top, -8)
                .foregroundColor(.white)
                .bold()
                
                // Place of Interest List – Now fully scrollable
                ZStack {
                    // Blurred background image
                    Image("poii")
                        .resizable()
                        .scaledToFill()           // Fill the entire container
                        .blur(radius: 5)
                        .clipped()                // Prevent overflow outside the ZStack
                    
                    // Scrollable list of POIs
                    ScrollView {
                        LazyVStack(spacing: 6) {
                            ForEach(vm.pois) { poi in
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        vm.focus(
                                            on: CLLocationCoordinate2D(
                                                latitude: poi.latitude,
                                                longitude: poi.longitude
                                            )
                                        )
                                        
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.yellow)
                                            .scaleEffect(0.8)
                                        
                                        Text(poi.name)
                                            .foregroundColor(.white)
                                            .font(.footnote.bold())
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                   
                                }
                                .buttonStyle(.plain)
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.96)),
                                    removal: .opacity
                                ))
                                .onAppear {
                                    withAnimation(.easeOut(duration: 0.35)) {}
                                }
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
                .frame(minHeight: 260)   // Ensures the blurred area has enough space even with few items
                
                
                Spacer(minLength: 100) // Extra space at bottom for better scrolling feel
            }
        }
        .reusableSearchBar()
        
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    MapView()
        .environmentObject(vm)
}

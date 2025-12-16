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

    
    // MARK:  add other necessary variables
    var body: some View {
        VStack{
            // Map Display
            Map(position: $vm.mapRegion)
                .frame(height: 300)
                
            // Text detail
            HStack(spacing: 0){
                Text("Top 5 Tourist attractions in ")
                Text("\(vm.activePlaceName)").bold().foregroundStyle(.blue)
                    .padding(.vertical, 20)
            }.frame(maxWidth: .infinity).background(Color(.blue).opacity(0.3)).padding(.top, -08).foregroundColor(Color.white).bold()
            
            // Place of Interest List
            ZStack{
                HStack{
                    List(vm.pois) { poi in
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                vm.focus(
                                    on: CLLocationCoordinate2D(
                                        latitude: poi.latitude,
                                        longitude: poi.longitude
                                    )
                                )
                                vm.selectedTab = 2
                            }
                        } label: {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(Color.yellow)
                                    .scaleEffect(1.0) // base
                                Text(poi.name)
                                    .foregroundColor(Color.white)
                            }
                            .listRowBackground(Color.black.opacity(0.4))
                            .listRowInsets(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                            .padding(.horizontal, 30)
                            // Subtle press feedback
                            .contentShape(Rectangle())
                            .animation(.easeInOut(duration: 0.2), value: vm.selectedTab)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                        // Row appear animation
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.96)),
                                                removal: .opacity))
                        .onAppear {
                            // Animate each row as it appears (use id to stagger if desired)
                            withAnimation(.easeOut(duration: 0.35)) {}
                        }
                    }
                    .listStyle(.plain)
                    .listRowSpacing(1)
                    
                }.frame(height: 260)
                    .background(
                        Image("poii")
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 5)
                        .cornerRadius(0)
                )
            }.offset(y: -10)
            
        }
        // Default search bar and gradient background
        .reusableSearchBar()
        
    }
}
#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    MapView()
        .environmentObject(vm)
}

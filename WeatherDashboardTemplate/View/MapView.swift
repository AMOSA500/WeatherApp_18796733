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
                        HStack{
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color.yellow)
                            Text(poi.name).foregroundColor(Color.white)
                        }
                        .listRowBackground(Color.black.opacity(0.4))
                        .listRowInsets(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))

                        .padding(.horizontal, 30)
                        
                    }
                    .listStyle(.plain)
                    .listRowSpacing(1)
                    
                }.frame(height: 260)
                    .background(
                        Image("poii")
                        .resizable()
                        .scaledToFit()
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

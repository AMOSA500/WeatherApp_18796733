//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData
import MapKit

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    // MARK:  add other necessary variables
    var body: some View {
        VStack{
            // Map Display
            VStack{
                
                Map(position: $vm.mapPosition).frame(height: 300)
            }
            // Text detail
            HStack{
                Text("Top 5 Tourist attractions in {London}").padding(10)
            }.frame(maxWidth: .infinity).background(Color(.blue).opacity(0.3)).padding(.top, -08).foregroundColor(Color.white).bold()
            // Place of Interest List
            ZStack{
                Image("poii")
                    .resizable()
                    .scaledToFit()
                    .blur(radius: 1)
                    .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .leading){
                    
                    ForEach(1...3, id: \.self) { _ in
                        HStack{
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color.yellow)
                            Text("Place of Interest").foregroundColor(Color.white)
                            Spacer()
                        }
                            
                    }
                }.padding(.horizontal)
            }
            Spacer()
        }
        .reusableSearchBar()
        
    }
}
#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    MapView()
        .environmentObject(vm)
}

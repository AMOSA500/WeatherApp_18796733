//
//  VisitedPLacesView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData


struct VisitedPlacesView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.modelContext) private var context
    @State private var formatMyDate: DateFormatterUtils = DateFormatterUtils()
    
    

    // MARK:  add local variables for this view


    var body: some View {
        VStack {
            HStack {
                Text("Visited Places 📍")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .font(.system(size: 32)).bold()
            }

            if vm.visited.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("No visited places yet")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Search for a city to get started.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(vm.visited) { place in
                        
                        Button {
                            Task { await vm.loadLocation(fromPlace: place) }
                            vm.selectedTab = 2
                        } label: {
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(place.name).bold()
                                        .font(.subheadline)
                                    Text("Lat: \(place.latitude) - Lon: \(place.longitude)").foregroundStyle(.secondary)
                                    if let last = (Optional(place.lastUsedAt)) {
                                        Text(
                                            DateFormatterUtils.prettyDateTimeWithZone
                                                .string(from: last)
                                        ).foregroundStyle(.secondary)
                                    }

                                }
                                Spacer()
                               
                            }.padding(10)
                            
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                       
                    }
                    
                    .onDelete { indexSet in
                        for index in indexSet {
                            let place = vm.visited[index]
                            vm.delete(place: place)
                        }
                    }
                    
                }
                .listStyle(.plain)
                // list is up-to-date and sorted whenever it appears
                .onAppear {
                    withAnimation {
                        vm.visited = vm.visited.sorted {
                            ($0.lastUsedAt) > ($1.lastUsedAt)
                        }
                    }
                }
            }
        }
        .reusableSearchBar()
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    VisitedPlacesView()
        .environmentObject(vm)
}

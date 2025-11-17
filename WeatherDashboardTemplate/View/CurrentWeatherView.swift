//
//  CurrentWeatherView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData


struct CurrentWeatherView: View {
    @EnvironmentObject var vm: MainAppViewModel

    var body: some View {
        VStack{
            HStack {
                Text("London").font(.largeTitle.bold())
                Spacer()
                Text("Sunday, Oct 19").font(.system(size: 18).bold())
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            // Your weather content goes here…

            Spacer(minLength: 0)
        }
        .background(Color.clear)
        .reusableSearchBar()
        
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    CurrentWeatherView()
        .environmentObject(vm)
}

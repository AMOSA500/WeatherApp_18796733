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
            HStack{
                Text("London").font(Font.largeTitle.bold())
                Spacer()
                Text("Sunday, Oct 19").font(Font.system(size: 18).bold())
            }.padding(20)
            Spacer()
        }
        
        
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    CurrentWeatherView()
        .environmentObject(vm)
}

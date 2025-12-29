//
//  SplashView.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 22/12/2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0x13/255.0, green: 0x2A/255.0, blue: 0x3A/255.0) // #132A3A (darker)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "cloud.sun.rain.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(Color.teal)
                    .padding(.top, 120)
                VStack{
                    Text("Weather Forecast").font(.system(size: 32)).foregroundStyle(Color.white)
                    Text("get weather, see forecast")
                        .foregroundStyle(
                            Color(
                                red: 0x62/255.0,
                                green: 0x7E/255.0,
                                blue: 0x75/255.0
                            )
                        )
                        .font(.system(size: 12))
                }.padding(.bottom, 120)
                
                ProgressView()
                    .progressViewStyle(.circular).tint(Color(red: 0x62/255.0, green: 0x7E/255.0, blue: 0x75/255.0))
                Text("Loading…")
                    .font(.headline)
                    .foregroundStyle(.white).padding(.bottom, 0)
                    .font(.system(size: 12))
                Spacer()
                VStack{
                    Text("Powered by OpenWeather API data")
                        .foregroundStyle(
                            Color(
                                red: 0x62/255.0,
                                green: 0x7E/255.0,
                                blue: 0x75/255.0
                            )
                        )
                        .font(.system(size: 12))
                    Text("© Nafiu Amosa")
                        .foregroundStyle(
                            Color(
                                red: 0x62/255.0,
                                green: 0x7E/255.0,
                                blue: 0x75/255.0
                            )
                        )
                        .font(.system(size: 12))
                }
            }
        }
    }
}

#Preview {
    SplashView()
}


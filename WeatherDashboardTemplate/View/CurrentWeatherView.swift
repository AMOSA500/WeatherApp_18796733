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
        // Your weather content goes here…
        VStack{
            HStack {
                Text("London").font(.largeTitle.bold())
                Spacer()
                Text("Sunday, Oct 19").font(.system(size: 18).bold())
            }
            .padding(.horizontal, 20)
            .padding(.top, 5)
            
            VStack {
                // Temperature Condition
                HStack {
                    Text("15 °C")
                        .font(.system(size: 60, design: .rounded))
                        .bold()
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 60))
                        .padding(.horizontal,5)
                        .padding(.top, 10)
                }
                // Rain condition
                HStack{
                    Text("Light Rain").bold().font(.system(size: 24))
                    Spacer()
                    Text("Wind: 10 m/s")
                }.padding(.horizontal,10).padding(.top, 1)
                
                // High and Low condition
                HStack(spacing: 30){
                    HStack{
                        Image(systemName: "arrow.up").bold().font(Font.system(size: 18))
                        Text("15 °C").bold().font(.system(size: 18))
                    }
                    HStack{
                        Image(systemName: "arrow.down").bold().font(Font.system(size: 18))
                        Text("12 °C").bold().font(.system(size: 18))
                    }
                    Spacer()
                    
                    
                }.padding(.horizontal,10).padding(.vertical, 10)
                
                // Divider
                Divider()
                
                // Details text
                HStack{
                    Text("Details").bold()
                        .font(.system(size: 24))
                        .foregroundStyle(.gray)
                }.frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.vertical, 5)
                
                // Pressure, Sunrise and Sunset
                VStack{
                    HStack{
                        Image(systemName: "barometer")
                            .bold()
                            .font(Font.system(size: 20))
                            .foregroundStyle(.blue)
                            .frame(width: 40, alignment: .leading)
                        Text("Pressure").font(.system(size: 24))
                        Spacer()
                        Text("1013 hPa").font(.system(size: 20))
                    }.padding(.bottom, 10)
                    // Sunrise
                    HStack{
                        Image(systemName: "sunrise.fill")
                            .bold()
                            .font(Font.system(size: 20))
                            .foregroundStyle(.blue)
                            .frame(width: 40, alignment: .leading)
                        Text("Sunrise").font(.system(size: 24))
                        Spacer()
                        Text("07:31").font(.system(size: 20))
                    }.padding(.bottom, 10)
                    
                    // Sunset
                    HStack{
                        Image(systemName: "sunset.fill")
                            .bold()
                            .font(Font.system(size: 20))
                            .foregroundStyle(.blue)
                            .frame(width: 40, alignment: .leading)
                        Text("Sunset").font(.system(size: 24))
                        Spacer()
                        Text("17:59").font(.system(size: 20))
                    }.padding(.bottom, 10)
                    
                }
                Divider()
                ZStack{
                    HStack(spacing: 10){
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 60))
                            .padding(.horizontal,5)
                            .padding(.top, 10)
                            .foregroundStyle(.green)
                        
                        Text("Mild weather - a light sweeter should do.")
                            .font(Font.system(size: 20))
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                    
                    
                }.background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 15)
                )
                
                
            }
            .padding()
            .background(
                // controll for stack shadow
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 0.7))
                        .fill(.ultraThinMaterial.opacity(0.1))
                        .shadow(radius: 5, x: 5, y: 5)
                }
            )
            
            .padding(.horizontal)
            
            
            
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

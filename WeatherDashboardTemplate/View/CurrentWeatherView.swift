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
    
    var category: WeatherAdviceCategory{
        guard let temp = vm.currentWeather?.main.temp else {
            return .unknown
        }
        return WeatherAdviceCategory.from(temp: temp, description: "")
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack {
                    Text(vm.activePlaceName).font(.title.bold())
                    Spacer()
                    Text(DateFormatterUtils.formattedWeekdayMonthDay(from: TimeInterval(vm.currentWeather?.dt ?? 0)))
                        .font(.system(size: 14).bold())
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                
                VStack {
                    // Temperature Condition
                    HStack {
                        Text("\(Int(vm.currentWeather?.main.temp ?? 0)) °C")
                            .font(.system(size: 60, design: .rounded))
                            .bold()
                        
                        Spacer()
                        
                        openWeatherIcon("\(vm.currentWeather?.weather[0].icon ?? "N/A")")
                            .font(.system(size: 60))
                            .padding(.horizontal,5)
                            .foregroundStyle(category.color)
                    }
                    // Rain condition
                    HStack{
                        Text(
                            "\(vm.currentWeather?.weather[0].description ?? "N/A")".capitalized
                        )
                        .bold()
                        .font(.system(size: 14))
                        Spacer()
                        Text("Wind: \(String(format: "%.1f", vm.currentWeather?.wind?.speed ?? 0.0)) m/s").font(.system(size: 14))
                    }.padding(.horizontal,10)
                    
                    // High and Low condition
                    HStack(spacing: 30){
                        HStack{
                            Image(systemName: "arrow.up").bold().font(Font.system(size: 18))
                            Text(
                                "\(String(format: "%.1f", vm.currentWeather?.main.tempMax ?? 0.0)) °C"
                            )
                            .bold()
                            .font(.system(size: 18))
                        }
                        HStack{
                            Image(systemName: "arrow.down").bold().font(Font.system(size: 18))
                            Text(
                                "\(String(format: "%.1f", vm.currentWeather?.main.tempMin ?? 0.0)) °C"
                            )
                            .bold()
                            .font(.system(size: 18))
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
                            Text("\(vm.currentWeather?.main.pressure ?? 0) hPa")
                                .font(.system(size: 20))
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
                            Text(
                                DateFormatterUtils
                                    .formattedDate24Hour(
                                        from: TimeInterval(
                                            vm.currentWeather?.sys.sunrise ?? 0
                                        )
                                    )
                            )
                            .font(.system(size: 20))
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
                            Text(DateFormatterUtils
                                .formattedDate24Hour(
                                    from: TimeInterval(
                                        vm.currentWeather?.sys.sunset ?? 0
                                    )
                                )).font(.system(size: 20))
                        }.padding(.bottom, 10)
                        
                    }
                    Divider()
                    ZStack{
                        HStack(spacing: 10){
                            openWeatherIcon("\(vm.currentWeather?.weather[0].icon ?? "N/A")")
                                .font(.system(size: 50))
                                .padding(.horizontal,5)
                                .foregroundStyle(.green)
                            
                            Text(category.adviceText)
                                .font(.system(size: 12).bold())
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(0)
                        
                        
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

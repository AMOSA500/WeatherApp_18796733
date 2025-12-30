//
//  ForecastView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import Charts
import SwiftData


import SwiftUI
import Charts   // Include if you plan to show a chart later


// MARK: - Forecast View
/// Stubbed Forecast View that includes an image placeholder to show
/// what the final view will look like. Replace the image once real data and charts are added.
struct ForecastView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    
    var body: some View {
        ScrollView{
        VStack {
            // MARK: - Header Text
            VStack{
                HStack{
                    Text("8-Day Forecast - \(vm.activePlaceName)")
                        .font(.title3)
                        .padding(.top)
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Text("Daily High and Lows (°C)").font(.footnote)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 20)
            if vm.dailyHighLowForecast.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("No weather forecast data yet")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Search for a city to get started.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                // Bar chart
                
                Chart(vm.dailyHighLowForecast) { item in
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Temperature", item.value),
                        width: 20
                    )
                    .annotation(position: .top, spacing: -20){
                        Text(String(Int(item.value)))
                            .foregroundStyle(Color.white)
                            .font(.system(size: 10))
                    }
                    .foregroundStyle(by: .value("Type", item.type.rawValue))
                    .position(by: .value("Type", item.type.rawValue))
                }
                .chartForegroundStyleScale([
                    "High": .red,
                    "Low": .blue
                ])
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(
                            format: .dateTime.weekday(.abbreviated),
                            centered: true
                        )
                        AxisGridLine()
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing)
                }
                .frame(height: 260)
                .padding()
                
                
            }
            
            
            Divider()
            
            HStack{
                Text("Detailed Daily Summary")
                    .font(.system(size: 20, weight: .bold))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .init(
                            horizontal: .leading,
                            vertical: .center
                        )
                    )
                    .padding(.horizontal)
            }
            VStack{
                    
                    VStack{
                        ForEach(vm.forecast) { data in
                            var adviceCategory : WeatherAdviceCategory{
                                return WeatherAdviceCategory
                                    .from(temp: data.temperature, description: "")
                            }
                            HStack{
                                HStack{
                                    openWeatherIcon(data.icon)
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }.frame(alignment: .leading)
                                VStack{
                                    HStack{
                                        Text(DateFormatterUtils.formattedWeekdayMonthDay(from: TimeInterval(data.time))).bold()
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        Text(
                                            adviceCategory.adviceText
                                        )
                                        .font(Font.subheadline.italic())
                                        .foregroundStyle(Color.gray)
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        Text("Low: \(String(format: "%0.1f" ,(data.tempMin))) °C High: \(String(format: "%0.1f" ,(data.tempMax))) °C ")
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }.frame(alignment: .trailing)
                            }
                            
                            Divider()
                        }
                    }.frame(maxWidth: .infinity).padding()
                        .background(
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 0.7))
                                    .fill(.ultraThinMaterial.opacity(0.5))
                            }
                        )
                        .scrollContentBackground(.automatic)
                    
                    
                
            }.padding()
        }
            
            Spacer()
            
        }.reusableSearchBar()
    }
    
    
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    ForecastView()
        .environmentObject(vm)
}

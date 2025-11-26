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
    
    /// Converts forecast data into chart-friendly entries.
    private var chartData: [TempData] {
       // vm.forecast.flatMap { day in
            [
                // These are hard-wired data, real data will come from weather data fetched by your api
                
                TempData(
                    time: Date(),
                    type: "High",
                    value: 24.5,
                    category: .from(tempC: 24.5)
                ),
                TempData(
                    time: Date(),
                    type: "Low",
                    value: 4.5,
                    category: .from(tempC: 4.5)
                ),
                TempData(
                    time: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                    type: "High",
                    value: 19.0,
                    category: .from(tempC: 19.0)
                ),
                TempData(
                    time: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                    type: "Low",
                    value: 5.5,
                    category: .from(tempC: 5.5)
                )
                // TODO: add a "Low" entry or other data points if needed
            ]
       // }
    }
    
    var body: some View {
        VStack {
            // MARK: - Header Text
            VStack{
                HStack{
                    Text("8 Day Forecast - London")
                        .font(.title)
                        .padding(.top)
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Text("Daily High and Lows (°C)")
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 20)
            
            // Bar chart
            Chart(chartData) { data in
                BarMark(
                    x: .value("Day", data.time, unit: .day),
                    y: .value("Temperature", data.value)
                )
                .foregroundStyle(data.category.color)
                .position(by: .value("Type", data.type))
            }
           
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
                
            }
            .chartYAxis{
                AxisMarks(values: .stride(by: 10)){ value in
                    AxisValueLabel()
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
            }
            
            .frame(height: 250)
            .padding()
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
                ScrollView{
                    
                        VStack{
                            ForEach(1...5, id: \.self) { data in
                                VStack{
                                    HStack{
                                        Text("Sunday, Oct 18").bold()
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        Text("Expected a day with some rain").font(Font.caption.italic()).foregroundStyle(Color.gray)
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        Text("Low: 1 °C High: 15 °C ")
                                    }.frame(maxWidth: .infinity, alignment: .leading)
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
                        
                    
                }
            }.padding()

            
            Spacer()
        }.reusableSearchBar()
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    ForecastView()
        .environmentObject(vm)
}

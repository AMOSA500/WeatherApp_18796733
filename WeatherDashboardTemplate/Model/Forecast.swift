//
//  Forecast.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 19/11/2025.
//

import Foundation


struct Forecast: Decodable, Identifiable {
    var id: TimeInterval {TimeInterval(time)}
    let time: Int
    let temperature: Double
    let tempMax: Double
    let tempMin: Double
    let icon: String


    enum CodingKeys: String, CodingKey{
        case time = "dt"
        case main = "main"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case temperature = "temp"
        case icon
        case weather


    }
    
    /// Custom decoding
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)

        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherContainer.nestedContainer(keyedBy: CodingKeys.self)
        icon = try weather.decode(String.self, forKey: .icon)
        temperature = try main.decode(Double.self, forKey: .temperature)
        tempMax = try main.decode(Double.self, forKey: .tempMax)
        tempMin = try main.decode(Double.self, forKey: .tempMin)

    }
}

struct ForecastWeather: Decodable {
    let list: [Forecast]
}

/// Customised
struct DailyTemperature: Identifiable {
    let id = UUID()
    let date: Date
    let type: TempType
    let value: Double
}

enum TempType: String {
    case high = "High"
    case low = "Low"
}


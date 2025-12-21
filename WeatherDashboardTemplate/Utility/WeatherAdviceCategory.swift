//
//  WeatherAdviceCategory.swift
//  WeatherDashboard
//
//  Created by girish lukka on 11/10/2025.
//  Created by Nafiu Amosa on 11/11/2025.

import Foundation
import SwiftUI

enum WeatherAdviceCategory: String {
    case freezing, cold, mild, warm, hot, unknown

    static func from(temp: Double, description: String) -> WeatherAdviceCategory {
        //let normalized = description.lowercased()
        if temp < 0 { return .freezing }
        else if temp < 10 { return .cold }
        else if temp < 20 { return .mild }
        else if temp < 28 { return .warm }
        else { return .hot }
    }

//    var icon: String {
//        switch self {
//        case .freezing: return "snowflake"
//        case .cold: return "cloud.snow.fill"
//        case .mild: return "cloud.sun.fill"
//        case .warm: return "sun.max.fill"
//        case .hot: return "thermometer.sun.fill"
//        case .unknown: return "questionmark.circle"
//        }
//    }
//    
    

    var adviceText: String {
        switch self {
        case .freezing:
            return "It's freezing outside — bundle up and stay warm!"
        case .cold:
            return "A bit chilly today — wear a jacket or coat."
        case .mild:
            return "Mild weather — a light sweater should do."
        case .warm:
            return "Comfortably warm — perfect for outdoor activities. Don't forget sunscreen!"
        case .hot:
            return "Very hot today! Stay hydrated, wear light clothing, and apply sunscreen."
        case .unknown:
            return "Weather is unpredictable — dress in layers and check before heading out."
        }
    }

    var color: Color {
        switch self {
        case .freezing: return .blue
        case .cold: return .accentColor
        case .mild: return .green
        case .warm: return .orange
        case .hot: return .red
        case .unknown: return .gray
        }
    }
}
// Nafiu Amosa Contribution
func systemIcon(for openWeatherIcon: String) -> String {
    switch openWeatherIcon {
    case "01d": return "sun.max.fill"
    case "01n": return "moon.stars.fill"
    case "02d": return "cloud.sun.fill"
    case "02n": return "cloud.moon.fill"
    case "03d", "03n": return "cloud.fill"
    case "04d", "04n": return "smoke.fill" // or "cloud.fill"
    case "09d", "09n": return "cloud.rain.fill"
    case "10d": return "cloud.sun.rain.fill"
    case "10n": return "cloud.moon.rain.fill"
    case "11d", "11n": return "cloud.bolt.rain.fill"
    case "13d", "13n": return "cloud.snow.fill"
    case "50d", "50n": return "cloud.fog.fill"
    default: return "questionmark.circle"
    }
}


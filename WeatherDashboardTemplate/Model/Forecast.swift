//
//  Forecast.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 19/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Temperature Category
/// Example of how to categorize temperatures for display.
/// Add more cases or adjust logic as needed.
enum TempCategory: String, CaseIterable {
    case cold = "Cold"
    case cool = "Cool"
    case warm = "Warm"
    case hot = "Hot"
    
    
    /// Choose a color to represent this category.
    var color: Color {
        switch self {
        case .cold:
            return .blue
        case .cool:
            return .cyan
        case .warm:
            return .orange
        case .hot:
            return .red
        }
    }
    
    /// Convert a Celsius temperature into a category.
    static func from(tempC: Double) -> TempCategory {
        if tempC <= 0 {
            return .cold
        }
        else if tempC > 0 && tempC <= 14 {
            return .cool
        }
        else if tempC > 14 && tempC <= 29 {
            return .warm
        }
        else {
            return .hot
        }
    }
}

// MARK: - Temperature Data Model
/// A single temperature reading for the chart or list.
 struct TempData: Identifiable {
    let id = UUID()
    let time: Date          // e.g., forecast date
    let type: String        // e.g., "High" or "Low"
    let value: Double       // numeric value
    let category: TempCategory
}

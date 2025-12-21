//
//  openWeatherIcon.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 19/12/2025.
//

import Foundation
import SwiftUI

@ViewBuilder
 func openWeatherIcon(_ iconCodeRaw: String) -> some View {
    AsyncImage(url: {
        // Build OpenWeather icon URL from a code like "10d"
        let iconCode = iconCodeRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !iconCode.isEmpty,
              let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") else {
            return nil
        }
        return url
    }()) { phase in
        switch phase {
        case .empty:
            ProgressView().frame(width: 40, height: 40)
        case .success(let image):
            image
        case .failure:
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .frame(width: 40, height: 40)
        @unknown default:
            EmptyView()
        }
    }
}

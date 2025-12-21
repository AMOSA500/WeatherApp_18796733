//
//  ForecastService.swift
//  WeatherDashboardTemplate
//
//  Created by Nafiu Amosa on 17/12/2025.
//

import Foundation

@MainActor // run in the main thread
final class ForecastService: ObservableObject {
        
    func fetchForecast(city: String) async throws -> ForecastWeather {
        
        guard var urlComponents = URLComponents(string: WeatherAPI.baseForecastURL) else {
            throw WeatherMapError.invalidURL("Invalid base URL")
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city.lowercased()),
            URLQueryItem(name: "appid", value: WeatherAPI.apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents.url else {
            throw WeatherMapError.invalidURL("Invalid base URL")
        }
        
        
        let (data, response) = try await URLSession.shared.data(from: url)
        

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherMapError.invalidResponse(statusCode: 404)
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 404 {
                throw WeatherMapError.geocodingFailed("City not found")
            } else {
                throw WeatherMapError
                    .decodingError("Failed to decode data" as! Error)
            }
        }

        do {
            let forecast = try JSONDecoder().decode(ForecastWeather.self, from: data)
            return forecast
        } catch {
            throw WeatherMapError.decodingError(error)
        }
    }
    
    func filterHighLowForecast(forecast: [Forecast]) -> [Forecast] {
        let totalRecords = forecast.count
        guard totalRecords == 40 else { return forecast }
        
        var filtered: [Forecast] = []
        for day in 0...5{
            let startIndex = day * 8
            if startIndex < totalRecords {
                filtered.append(forecast[startIndex])
            }
            if startIndex + 4 < totalRecords {
                filtered.append(forecast[startIndex + 4])
            }
            
        }
        return filtered
    }
    
    func filterSingleForecast(forecast: [Forecast]) -> [Forecast] {
        let grouped = Dictionary(grouping: forecast){ item in
            Calendar.current
                .startOfDay(for: Date(timeIntervalSince1970: TimeInterval(item.time)))
        }
        let sortedDays = grouped.keys.sorted()
        var dailyForecasts: [Forecast] = []
        
        for day in sortedDays.prefix(7) {
            if let entries = grouped[day] {
                if let noonEntry = entries.first(
                    where: { Calendar.current.component(
                        .hour,
                        from: Date(timeIntervalSince1970: TimeInterval($0.time))
                    ) == 12
                    }) {
                    dailyForecasts.append(noonEntry)
                }else{
                    dailyForecasts.append(entries.first!)
                }
            }
        }
        return dailyForecasts
        
    }
    
    
}

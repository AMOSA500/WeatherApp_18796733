//
//  WeatherService.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import Foundation
@MainActor
final class WeatherService {
    
    func fetchWeather(city: String) async throws -> WeatherResponse {
        
        guard var urlComponents = URLComponents(string: WeatherAPI.baseURL) else {
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
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            throw WeatherMapError
                .decodingError("Failed to decode data" as! Error)
        }
    }
    
    

    /*
    func fetchCurrent(lat: Double, lon: Double) async throws -> Weather {
        let response = try await fetchWeather(lat: lat, lon: lon)

        // Prefer an explicit current if it exists (uncomment if your model adds it later)
        // return response.current

        // Fall back to the first daily item if available
        if let firstDaily = (response as AnyObject).value(forKey: "daily") as? [Weather], let day = firstDaily.first {
            return day
        }

        // Or fall back to the first hourly item if available
        if let firstHourly = (response as AnyObject).value(forKey: "hourly") as? [Weather], let hour = firstHourly.first {
            return hour
        }
        // If your WeatherResponse defines another suitable property, adapt here accordingly
        throw WeatherMapError.decodingError(NSError(domain: "WeatherService", code: 0, userInfo: [NSLocalizedDescriptionKey: "WeatherResponse does not contain a current, daily, or hourly weather item."]))
    }*/
    /** MARK: - Convenience APIs used by the ViewModel
    func fetchForecast(lat: Double, lon: Double) async throws -> [Weather] {
        let response = try await fetchWeather(lat: lat, lon: lon)
        // If WeatherResponse has `daily: [Weather]`, return it. Otherwise adapt as needed.
        return response.daily
    }
     **/
}


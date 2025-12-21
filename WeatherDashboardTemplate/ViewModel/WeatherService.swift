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
    
    

    
}


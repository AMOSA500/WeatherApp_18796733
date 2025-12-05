//
//  WeatherService.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import Foundation
@MainActor
final class WeatherService {
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        // Constructs a URL for the OpenWeatherMap OneCall API using the provided coordinates and API key.
        // Performs an asynchronous network request using URLSession.
        // Validates the HTTP response status code.
        // Decodes the received JSON data into a `WeatherResponse` object, using a specific date decoding strategy.
        // Handles and throws specific `WeatherMapError` types for invalid URL, network failure, invalid response, and decoding errors.
           let urlString = "\(WeatherAPI.baseURL)\(WeatherAPI.oneCallEndpoint)?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&units=metric&appid=\(WeatherAPI.apiKey)"

           guard let url = URL(string: urlString) else {
               throw WeatherMapError.invalidURL("Invalid URL")
           }

           do {
               let (data, response) = try await URLSession.shared.data(from: url)

               guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                   throw WeatherMapError.invalidResponse(statusCode: 404)
               }

               let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .secondsSince1970

               do {
                   let weather = try decoder.decode(WeatherResponse.self, from: data)
                   return weather
               } catch {
                   throw WeatherMapError.decodingError(error)
               }

           } catch {
               throw WeatherMapError.networkError(error)
           }
    }

    /** MARK: - Convenience APIs used by the ViewModel

    func fetchCurrent(lat: Double, lon: Double) async throws -> Weather {
        let response = try await fetchWeather(lat: lat, lon: lon)
        // If WeatherResponse has `current: Weather`, return it. Otherwise adapt as needed.
        #if DEBUG
        // no-op
        #endif
        return response.current
    }

    func fetchForecast(lat: Double, lon: Double) async throws -> [Weather] {
        let response = try await fetchWeather(lat: lat, lon: lon)
        // If WeatherResponse has `daily: [Weather]`, return it. Otherwise adapt as needed.
        return response.daily
    }
     **/
}

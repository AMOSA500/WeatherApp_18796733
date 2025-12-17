//
//  WeatherResponse.swift
//  WeatherDashboardTemplate
//
//  Updated by Nafiu Amosa on 02/12/2025

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: jsonData)

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind?
    let rain: Rain?
    let dt: Int
    let sys: Sys
    let name: String

    enum CodingKeys: String, CodingKey {
        case coord, weather, main, wind, rain, dt, sys, name
    }
}

// MARK: - Coord
struct Coord: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude  = "lat"
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin   = "temp_min"
        case tempMax   = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let name: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case name = "main"
        case description, icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}


// MARK: - Rain
struct Rain: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int

}

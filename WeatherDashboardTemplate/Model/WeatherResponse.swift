//
//  WeatherResponse.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//  Updated by Nafiu Amosa on 02/12/2025

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: jsonData)

// MARK:  You can use this file however you will not get any credit for it. You must create your own WeatherResponse that is specific for your app and that it is efficient

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]        // short description + icon
    let main: Main                // temperature, humidity, pressure
    let wind: Wind?               // optional, not always present
    let clouds: Clouds?           // optional
    let rain: Rain?               // optional
    let dt: Date                  // timestamp converted to Date
    let sys: Sys                  // country, sunrise/sunset
    let name: String              // city name

    enum CodingKeys: String, CodingKey {
        case coord, weather, main, wind, clouds, rain, dt, sys, name
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
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
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Rain
struct Rain: Codable {
    let oneHour: Double

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String
    let sunrise: Date
    let sunset: Date

    enum CodingKeys: String, CodingKey {
        case country, sunrise, sunset
    }
}

//
//  WeatherResponse.swift
//  WeatherDashboardTemplate
//
//  Updated by Nafiu Amosa on 02/12/2025

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
 struct ForecastResponse: Codable {
 let code: String
 let message: Int
 let count: Int
 let forecasts: [ForecastItem]
 let city: City
 
 enum CodingKeys: String, CodingKey {
 case code = "cod"
 case message, count = "cnt"
 case forecasts = "list"
 case city
 }
 }
 
 struct ForecastItem: Codable {
 let dt: Int
 let main: Main
 let weather: [Weather]
 let wind: Wind?
 let rain: Rain?
 let dtText: String? // maps dt_txt
 
 enum CodingKeys: String, CodingKey {
 case dt, main, weather, wind, rain
 case dtText = "dt_txt"
 }
 }
 
 struct City: Codable {
 let id: Int
 let name: String
 let coord: Coord
 let country: String
 let population: Int
 let timezone: Int
 let sunrise: Int
 let sunset: Int
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
 let threeHour: Double?
 
 enum CodingKeys: String, CodingKey {
 case oneHour = "1h"
 case threeHour = "3h"
 }
 }
 
 // MARK: - Sys
 struct Sys: Codable {
 let country: String
 let sunrise: Int
 let sunset: Int
 
 }
 
 

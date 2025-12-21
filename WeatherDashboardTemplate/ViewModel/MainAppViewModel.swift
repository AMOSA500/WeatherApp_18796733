//
//  MainAppViewModel.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData
import MapKit

@MainActor
final class MainAppViewModel: ObservableObject {
    @Published var query = ""
    @Published var currentWeather: WeatherResponse?
    @Published var forecast: [Forecast] = []
    @Published var pois: [AnnotationModel] = []
    @Published var mapRegion: MapCameraPosition = .automatic /// MKCoordinateRegion() is deprecated
    @Published var visited: [Place] = []
    @Published var isLoading = false
    @Published var appError: WeatherMapError?
    @Published var activePlaceName: String = ""
    private let defaultPlaceName: String
    @Published var selectedTab: Int = 0
    private var dailyHighLow: [Forecast] = []
        
    /// Filtered forecast weather
    var dailyHighLowForecast: [DailyTemperature] {
        guard dailyHighLow.count >= 8 else { return [] }

        // Group 3-hour forecasts by calendar day
        let groupedByDay = Dictionary(grouping: dailyHighLow) { item in
            Calendar.current.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(item.time))
            )
        }

        // Take the first 8 days only
        let sortedDays = groupedByDay.keys.sorted().prefix(8)

        var result: [DailyTemperature] = []

        for day in sortedDays {
            guard let items = groupedByDay[day] else { continue }
            let temps = items.map { $0.temperature }

            if let minTemp = temps.min(),
               let maxTemp = temps.max() {

                result.append(
                    DailyTemperature(
                        date: day,
                        type: .low,
                        value: minTemp
                    )
                )

                result.append(
                    DailyTemperature(
                        date: day,
                        type: .high,
                        value: maxTemp
                    )
                )
            }
        }

        return result
    }
  
    /// Initialise geocode
    let geocode = CLGeocoder()
    
    
    /// Create and use a WeatherService model (class) to manage fetching and decoding weather data
    private let weatherService = WeatherService()
    
    /// Create and use a ForecastService model (class) to manage fetching and decoding weather forecast data
    private let forecastService = ForecastService()
    
    /// Create and use a LocationManager model (class) to manage address conversion and tourist places
    private let locationManager = LocationManager()
    
    /// Use a context to manage database operations
    private let context: ModelContext
    
    init(context: ModelContext, defaultPlaceName: String = "London") {
        
        self.context = context
        self.defaultPlaceName = defaultPlaceName
        
        // Corrected FetchDescriptor to include sorting by 'lastUsedAt' in reverse order.
        if let results = try? context.fetch(
            FetchDescriptor<Place>(sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)])
        ) {
            self.visited = results
        }
        
        // First launch: no data → perform full London setup
        if visited.isEmpty {
            Task {
                await loadDefaultLocation()
            }
        } else if let mostRecent = visited.first {
            // Otherwise, load most recently used place
            Task {
                await loadLocation(fromPlace: mostRecent)
            }
        }
    }
    
    func submitQuery() async {
        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else {
            appError = .missingData(message: "Please enter a valid location.")
            return
        }
        
            do {
                // MARK: call loadLocation(byName:)
                try await loadLocation(byName: city)
                query = ""
            } catch {
                appError = .networkError(error)
            }
    }
    func loadDefaultLocation() async {
        // Attempts to select and load the hardcoded default location name.
        // If an error occurs during selection, sets an app error.
        do {
            let placemarks = try await geocode.geocodeAddressString(defaultPlaceName)
            guard let place = placemarks.first, let location = place.location else {
                appError = .missingData(message: "Unable to resolve default location.")
                return
            }
            let coord = location.coordinate
            mapRegion = .region(
                MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
            activePlaceName = defaultPlaceName
            
            pois = try await locationManager
                .findPOIs(lat: coord.latitude, lon: coord.longitude, limit: 5)
            
        }catch {
            appError = .geocodingFailed(defaultPlaceName)
        }
    }
    
    func search() async throws {
        // If the query is not empty, calls `select(placeNamed:)` with the current query string.
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        // If query is empty, reload all places sorted by most recent use
        if trimmed.isEmpty {
            let descriptor = FetchDescriptor<Place>(sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)])
            if let results = try? context.fetch(descriptor) {
                self.visited = results
            }
            
        }
        /// Check if already visited
        if let place = visited.first(where: { $0.name == trimmed }) {
            try await loadAll(for: place)
            place.lastUsedAt = Date()
            try context.save()
            
            self.activePlaceName = place.name
            mapRegion = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    ),
                    latitudinalMeters: 0.1,
                    longitudinalMeters: 0.1
                )
            )
            pois = try await locationManager
                .findPOIs(lat: place.latitude, lon: place.longitude, limit: 5)
            defer{
                isLoading = false
            }
            return
        }else{
            await submitQuery()
        }
        
    }
    
    /// Validate weather before saving a new place; create POI children once.
    func loadLocation(byName: String) async throws {
        do{
            ///  This lets the UI show a spinner or overlay while work is happening.
            isLoading = true
            
            
            /// geocodes the fresh place name
            let coordinates = try await locationManager.geocodeAddress(byName)
            
            /// Fetches weather data
            let weather = try await weatherService.fetchWeather(city: coordinates.name)
            self.currentWeather = weather
            
            /// Fetches forcast data
            let decodedForecast = try await forecastService.fetchForecast(city: coordinates.name)
            forecast = forecastService.filterSingleForecast(forecast: decodedForecast.list)
            dailyHighLow = forecastService
                .filterHighLowForecast(forecast: decodedForecast.list)
            
            
            /// Finds Points of Interest (POIs)
            let poisResponse = try await locationManager
                .findPOIs(
                    lat: coordinates.lat,
                    lon: coordinates.lon,
                    limit: 5
                )
            let newPlace = Place(
                name: coordinates.name,
                latitude: coordinates.lat,
                longitude: coordinates.lon,
                pois: poisResponse
            )
            
            /// insert place into visited and save it
            context.insert(newPlace) /// Todo review
            try context.save()
            
            visited.append(newPlace)
            
            activePlaceName = coordinates.name
            pois = poisResponse
            mapRegion = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinates.lat,
                        longitude: coordinates.lon
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
            
           
            defer{
                isLoading = false
            }
            
        }catch{
            activePlaceName = defaultPlaceName
            mapRegion = .automatic
            appError = .decodingError(error)
            defer{
                isLoading = false
            }
        }
        
    }
    /// Used by Visited Place View
    func loadLocation(fromPlace place: Place) async {
        isLoading = true
        do {
            try await loadAll(for: place)
            // Persist most-recent usage
            place.lastUsedAt = Date()
            try? context.save()
            activePlaceName = place.name
            isLoading = false
        } catch {
            defer{
                isLoading = false
            }
            appError = .decodingError(error)
        }
    }
    
    private func revertToDefaultWithAlert(message: String) async {
        appError = .missingData(message: message)
        await loadDefaultLocation()
    }
    
    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.02) {
        // Clamp zoom to a sensible range to avoid extreme values
        let clampedZoom = max(0.1, min(1.0, zoom))

        // Animate the map camera change for a smoother UX
        withAnimation(.easeInOut(duration: 0.35)) {
            mapRegion = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 1000 * clampedZoom,
                    longitudinalMeters: 1000 * clampedZoom
                )
            )
        }

    }
    
    private func loadAll(for place: Place) async throws {
        
        activePlaceName = place.name
        isLoading = true

        do {

            // Use cached annotations if present; otherwise fetch and cache
            if place.annotations.isEmpty {
                let fetchedPOIs = try await locationManager.findPOIs(
                    lat: place.latitude,
                    lon: place.longitude,
                    limit: 5
                )
                place.annotations = fetchedPOIs
                try? context.save()
                self.pois = fetchedPOIs
            } else {
                self.pois = place.annotations
            }

            mapRegion = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
            
            /// Fetches weather data
            let weather = try await weatherService.fetchWeather(city: place.name)
            self.currentWeather = weather
            
            /// Fetches forcast data
            let decodedForecast = try await forecastService.fetchForecast(city: place.name)
            forecast = forecastService.filterSingleForecast(forecast: decodedForecast.list)
            dailyHighLow = forecastService.filterHighLowForecast(forecast: decodedForecast.list)
            
            // Move this place to top of visited (most recent)
            place.lastUsedAt = Date()
            try? context.save()
            if let idx = visited.firstIndex(where: { $0.id == place.id }) {
                // Reorder locally to reflect most-recent-first
                var copy = visited
                let item = copy.remove(at: idx)
                copy.insert(item, at: 0)
                visited = copy
            } else {
                // If not present for some reason, insert it at the front
                visited.insert(place, at: 0)
            }
            
            // Must always run
            defer{
                isLoading = false
            }
        } catch {
            // On failure, surface error and keep previous state as much as possible
            defer{
                isLoading = false
            }
            appError = .decodingError(error)
            throw error
        }
    }
    
    func delete(place: Place) {
        /// Delete from visited array
        if let placeId = visited.firstIndex(where: {$0.id == place.id}){
            visited.remove(at: placeId)
        }
        
        /// Delete from swift data
        context.delete(place)
        
        do{
            try context.save()
            /// If the deleted place was the active one, then set the first place in visited as a sensible default
            if activePlaceName == place.name {
                activePlaceName = visited.first?.name ?? ""
            }
        }catch{
            /// If there was an error deleting a place, return the place back to visited array
            if visited.firstIndex(where: { $0.id == place.id }) == nil {
                visited.insert(place, at: 0)
            }

            appError = .decodingError(error)
        }
        
        
    }
    
    
    
    
    
}

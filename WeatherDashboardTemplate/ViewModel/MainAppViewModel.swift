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
    @Published var currentWeather: Weather?
    @Published var forecast: [Weather] = []
    @Published var pois: [AnnotationModel] = []
    @Published var mapRegion: MapCameraPosition = .automatic /// MKCoordinateRegion() is deprecated
    @Published var visited: [Place] = []
    @Published var isLoading = false
    @Published var appError: WeatherMapError?
    @Published var activePlaceName: String = ""
    private let defaultPlaceName = "Lagos, Nigeria" // Hardcoded since GPS usage is not within the scope
    @Published var selectedTab: Int = 0
    //@Published var mapPosition: MKCoordinateRegion()
    
    let geocode = CLGeocoder()
    
    
    /// Create and use a WeatherService model (class) to manage fetching and decoding weather data
    private let weatherService = WeatherService()
    
    /// Create and use a LocationManager model (class) to manage address conversion and tourist places
    private let locationManager = LocationManager()
    
    /// Use a context to manage database operations
    private let context: ModelContext
    
    init(context: ModelContext) {
        // Initialize the ModelContext and attempt to fetch previously visited places from SwiftData, sorted by most recent use.
        // If no visited places exist (first launch), load the default location.
        // Otherwise, load the most recently used place.
        self.context = context
        
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
    
    func submitQuery() {
        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else {
            appError = .missingData(message: "Please enter a valid location.")
            return
        }
        Task {
            do {
                // MARK: call loadLocation(byName:)
                try await loadLocation(byName: city)
                query = ""
            } catch {
                appError = .networkError(error)
            }
        }
    }
    func loadDefaultLocation() async {
        // Attempts to select and load the hardcoded default location name.
        // If an error occurs during selection, sets an app error.
        do {
            let placemarks = try await geocode.geocodeAddressString(defaultPlaceName)
            guard let place = placemarks.first, let location = place.location else {
                appError = .decodingError((any Error).self as! Error)
                return
            }
            let coord = location.coordinate
            mapRegion = .region(
                MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
            activePlaceName = place.name ?? defaultPlaceName
            
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
            return
        }
        // Filter by name case-insensitively
        let predicate = #Predicate<Place> { place in
            place.name.localizedStandardContains(trimmed)
        }
        let descriptor = FetchDescriptor<Place>(
            predicate: predicate,
            sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)]
        )
        if let results = try? context.fetch(descriptor) {
            self.visited = results
        }
    }
    
    /// Validate weather before saving a new place; create POI children once.
    func loadLocation(byName: String) async throws {
        /* Sets loading state, then attempts to load data for the given place name.
         1. Checks if the place is already in `visited` and, if so, loads all data for the existing `Place` object, updates its `lastUsedAt`, and saves the context.
         2. Otherwise, geocodes the fresh place name using `locationManager`.
         3. Fetches weather data using `weatherService` as a fail-fast check.
         4. Finds Points of Interest (POIs) using `locationManager`, converts them to `AnnotationModel`s, associates them with the new `Place`.
         5. Inserts the new `Place` into the `visited` array and saves the context.
         6. Updates UI by setting `pois`, `activePlaceName`, and focusing the map.
         7. If any step fails, logs the error and reverts to the default location with an alert.
         */
        
        do{
            ///  This lets the UI show a spinner or overlay while work is happening.
            isLoading = true
            
            /// Check if already visited
            if let place = visited.first(where: { $0.name == byName }) {
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
                isLoading = false
                return
            }
            /// geocodes the fresh place name
            let coordinates = try await locationManager.geocodeAddress(byName)
            /// Fetches weather data
            /*
            let weather = try await weatherService.fetchWeather(
                lat: coordinates.lat,
                lon: coordinates.lon
            )*/
            
            /// Finds Points of Interest (POIs)
            let poisResponse = try await locationManager
                .findPOIs(
                    lat: coordinates.lat,
                    lon: coordinates.lon,
                    limit: 5
                )
            let newPlace = Place(
                name: byName,
                latitude: coordinates.lat,
                longitude: coordinates.lon,
                pois: poisResponse
            )
            
            /// insert place into visited and save it
            context.insert(newPlace) /// Todo review
            try context.save()
            
            visited.append(newPlace)
            
            activePlaceName = byName
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
            for place in visited {
                print(place.name)
            }
            isLoading = false
            
        }catch{
            activePlaceName = defaultPlaceName
            mapRegion = .automatic
            appError = .decodingError(error)
            isLoading = false
        }
        
    }
    
    func loadLocation(fromPlace place: Place) async {
        // Sets loading state, then attempts to load all data for an existing `Place` object.
        // Updates the place's `lastUsedAt` and saves the context upon success.
        // Catches and sets `appError` for any failure during the load process.
        isLoading = true
        do {
            try await loadAll(for: place)
            // Persist most-recent usage
            place.lastUsedAt = Date()
            try? context.save()
            activePlaceName = place.name
            isLoading = false
        } catch {
            isLoading = false
            appError = .decodingError(error)
        }
    }
    
    private func revertToDefaultWithAlert(message: String) async {
        // Sets an `appError` with the given message, then calls `loadDefaultLocation()` to switch back to the default.
    }
    
    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.02) {
        // Animates the map region to center on the given coordinate with a specified zoom level (span).
    }
    
    private func loadAll(for place: Place) async throws {
        // Sets `activePlaceName` and prints a loading message.
        // Always refreshes weather data from the API.
        // Checks if the `Place` object has existing annotations (POIs).
        // If annotations are empty, fetches new POIs via `LocationManager`, adds them to the `Place`, saves the context, and sets `self.pois`.
        // If annotations exist, uses the cached list for `self.pois`.
        // Calls `focus(on:zoom:)` to update the map view.
        // Ensures the place is at the top of the `visited` list (if not already).
        
        activePlaceName = place.name
        isLoading = true

        do {
            // Refresh weather from API (ignore the result for now if model is pending)
            // let weather = try await weatherService.fetchWeather(lat: place.latitude, lon: place.longitude)
            // self.currentWeather = weather.current
            // self.forecast = weather.forecast

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

            // Focus map on this place
            mapRegion = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )

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

            isLoading = false
        } catch {
            // On failure, surface error and keep previous state as much as possible
            isLoading = false
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
            if visited.firstIndex(where: {$0.name == place.name}) == nil{
                visited.insert(place, at: 0)
            }
            appError = .decodingError(error)
        }
        
        
    }
    
}

//
//  LocationManager.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import Foundation
import CoreLocation
@preconcurrency import MapKit
import SwiftUI


@MainActor
final class LocationManager {

    func geocodeAddress(_ address: String) async throws -> (name: String, lat: Double, lon: Double) {
        // Uses `CLGeocoder` to convert a string address into geographic coordinates.
        // Extracts the name, latitude, and longitude from the first resulting placemark.
        // Throws a `WeatherMapError.geocodingFailed` if no valid location can be found.
        
        let geocode = CLGeocoder()
        let placemarks = try await geocode.geocodeAddressString(address)
        guard let first = placemarks.first,
              let location = first.location else {
            throw WeatherMapError.decodingError((any Error).self as! Error)
        }
        
        let name = first.name ?? address
        let coordinate = location.coordinate
        return (name, coordinate.latitude, coordinate.longitude)
    }
    
    func findPOIs(lat: Double, lon: Double, limit: Int = 5) async throws -> [AnnotationModel] {
        // Uses `MKLocalSearch` to find Points of Interest (POIs), specifically "Tourist Attractions," within a small region around the given latitude and longitude.
        // Executes the search request.
        // Maps the `MKMapItem` results into an array of `AnnotationModel`s, filtering out any without a name.
        // Limits the final array size to the specified `limit`.
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Tourist Attractions"
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let search = MKLocalSearch(request: request)
        do {
            let search_result = try await search.start()
            
            let poi_items: [MKMapItem] = Array(search_result.mapItems.prefix(limit))

            let annotations = poi_items.compactMap { item -> AnnotationModel? in
                let name = item.name ?? "Unknown"
                let coordinate = item.placemark.coordinate
                return AnnotationModel(
                    name: name,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            }
            
            return annotations
            
        } catch {
            throw error
        }
    }
}


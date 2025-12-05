//
//  Place.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//  Updated by Nafiu Amosa on 02/12/2025.


import SwiftData
import CoreLocation

@Model
final class Place {
    @Attribute(.unique) var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var lastUsedAt: Date
    
    // Relationship: one Place belongs to many Annotations
    @Relationship(deleteRule: .cascade, inverse: \AnnotationModel.place)
    var annotations: [AnnotationModel] = []

    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        pois: [AnnotationModel]
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.lastUsedAt = .now
        self.annotations = pois
    }
}

@Model
final class AnnotationModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    // Relationship: each Annotation belongs to one Place
    var place: Place?

    init(name: String, latitude: Double, longitude: Double, place: Place? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.place = place
    }
}

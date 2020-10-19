//
//  Place.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/18/20.
//

import CoreLocation

struct Place: Decodable {
    var identifier: String
    var type: String
    var name: String
    var population: Int
    var score: Double
    var coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case type
        case name
        case population
        case score
        case coordinates
    }
}

struct Coordinates: Decodable {
    var latitude: Double
    var longitude: Double
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

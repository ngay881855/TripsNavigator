//
//  Place.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/18/20.
//

import CoreLocation

struct Place: Decodable {
    var id: String
    var type: String
    var name: String
    var population: Int
    var coordinates: Coordinates
}

struct Coordinates: Decodable {
    var latitude: Double
    var longitude: Double
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

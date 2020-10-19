//
//  PlaceMarker.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import Foundation
import GoogleMaps

class PlaceMarker: GMSMarker {
    let population: Int
    let name: String
    
    init(place: Place) {
        self.population = place.population
        self.name = place.name
        super.init()
        position = CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
        groundAnchor = CGPoint(x: 0.5, y: 1.0)
        appearAnimation = .pop
    }
}

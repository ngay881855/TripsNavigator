//
//  PlaceAnnotation.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    let population: Int
    let score: Double
    let coordinate: CLLocationCoordinate2D
    let title: String?

    init(place: Place) {
        self.coordinate = place.coordinates.coordinates
        self.title = place.name
        self.population = place.population
        self.score = place.score
        super.init()
    }
    
    // swiftlint:disable discouraged_object_literal
    var image: UIImage {
        return #imageLiteral(resourceName: "default")
    }
}

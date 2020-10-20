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
    var mapItem: MKMapItem? {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        return mapItem
    }
    
    init(place: Place) {
        self.coordinate = place.coordinates.coordinates
        self.title = place.name
        self.population = place.population
        self.score = place.score
        super.init()
    }
}

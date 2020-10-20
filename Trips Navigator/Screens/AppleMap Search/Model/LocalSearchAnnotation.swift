//
//  LocalSearchAnnotation.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/20/20.
//

import Foundation
import MapKit

class LocalSearchAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    let mapItem: MKMapItem?
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name
        self.coordinate = mapItem.placemark.coordinate
        self.mapItem = mapItem
        super.init()
    }
    
    // swiftlint:disable discouraged_object_literal
    var image: UIImage {
        guard let category = mapItem?.pointOfInterestCategory else { return #imageLiteral(resourceName: "apple-logo") }
        
        switch category {
        case .airport:
            return #imageLiteral(resourceName: "airport")
            
        case .atm:
            return #imageLiteral(resourceName: "bank")
            
        case .hospital:
            return #imageLiteral(resourceName: "hospital")
            
        case .school:
            return #imageLiteral(resourceName: "school")
            
        default:
            return #imageLiteral(resourceName: "default")
        }
    }
}

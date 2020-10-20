//
//  PlaceView.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/20/20.
//

import Foundation
import MapKit

class PlaceView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let placeAnnotation = newValue as? PlaceAnnotation else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            guard let placeAnnotationView = UIView.viewFromNibName("PlaceMarkerView") as? PlaceMarkerView
            else {
                return
            }
            rightCalloutAccessoryView = placeAnnotationView
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = "Score: \(placeAnnotation.score)"
            detailCalloutAccessoryView = detailLabel
        }
    }
}

//
//  PlaceAnnotationView.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/20/20.
//

import Foundation
import MapKit

class PlaceAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: .zero)
        
        canShowCallout = true
        
        backgroundColor = .clear

        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
        mapsButton.setBackgroundImage(UIImage(named: "Map"), for: .normal)
        rightCalloutAccessoryView = mapsButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

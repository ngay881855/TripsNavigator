//
//  MKAnnotation+Ext.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/20/20.
//

import Foundation
import MapKit

extension MKAnnotation {
    var mapItem: MKMapItem? {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title ?? ""
        return mapItem
    }
}

//
//  ViewController.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/17/20.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
        }
    }
    
    // MARK: - Private properties
    private lazy var locationHandler = LocationHandler(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.locationHandler.getUserLocation()
    }
}

// MARK: - Extensions
extension GoogleMapViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func didFail(withError error: Error) {
        print(error)
    }
}

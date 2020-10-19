//
//  ViewController.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/17/20.
//

import GoogleMaps
import UIKit

class GoogleMapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
        }
    }
    
    // MARK: - Private properties
    private lazy var locationHandler = LocationHandler(delegate: self)
    var viewModel = PlaceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.locationHandler.getUserLocation()
        self.viewModel.delegate = self
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}

// MARK: - Extensions
extension GoogleMapViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        viewModel.searchData(with: "New York")
    }
    
    func didFail(withError error: Error) {
        print(error)
    }
}

extension GoogleMapViewController: PlaceViewModelProtocol {
    func addGMSMarker(with marker: PlaceMarker) {
        marker.map = mapView
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return self.viewModel.createMarker(with: marker)
    }
}

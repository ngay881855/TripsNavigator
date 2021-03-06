//
//  GoogleMapsViewController.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/17/20.
//

import GoogleMaps
import UIKit

class GoogleMapsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.mapView.settings.compassButton = true
        }
    }
    
    // MARK: - Private properties
    private lazy var locationHandler = LocationHandler(delegate: self)
    private var timer: Timer?
    
    // MARK: - Public properties
    var placeViewModel = PlaceViewModel()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.locationHandler.getUserLocation()
        self.placeViewModel.delegate = self
        
        self.title = "Trips Navigator"
    }
}

// MARK: - Extensions
extension GoogleMapsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { return }
        if let timer = self.timer {
            timer.invalidate()
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: Constants.timerIntervalToSearch, repeats: false) { _ in
            self.placeViewModel.searchData(with: searchText)
        }
    }
}

extension GoogleMapsViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
    }
    
    func didFail(withError error: Error) {
        print(error)
    }
}

extension GoogleMapsViewController: PlaceViewModelProtocol {
    func addGMSMarker(with marker: PlaceMarker) {
        marker.map = mapView
    }
    
    func removeGMSMarker(with marker: PlaceMarker) {
        marker.map = nil
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return self.placeViewModel.createMarker(with: marker)
    }
}

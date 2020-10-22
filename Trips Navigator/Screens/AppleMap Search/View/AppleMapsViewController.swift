//
//  AppleMapsViewController.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import MapKit
import UIKit

class AppleMapsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            self.mapView.showsUserLocation = true
            self.mapView.showsCompass = true
            self.mapView.delegate = self
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Public properties
    var placeViewModel = AppleMapsPlaceViewModel()
    
    // MARK: - Private properties
    private lazy var locationHandler = LocationHandler(delegate: self)
    private var timer: Timer?
    
    // MARK: - De-Initializers
    deinit {
        // De-initialize MVMapView Delegate
        self.mapView.delegate = nil
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let buttonItem = MKUserTrackingBarButtonItem(mapView: self.mapView)
        self.navigationItem.rightBarButtonItem = buttonItem
        
        self.locationHandler.getUserLocation()
        self.placeViewModel.delegate = self
        
        self.mapView.register(
            PlaceAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.reuseIdentifier)
        self.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.reuseIdentifier)
        
        self.title = "Trips Navigator"
    }
}

// MARK: - Extensions
// MARK: MKMapViewDelegate
extension AppleMapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if #available(iOS 11.0, *) {
            if annotation is MKClusterAnnotation {
                return nil
            }
        }
        return self.placeViewModel.createAnnotationView(viewFor: annotation, mapView: self.mapView)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else {
            return
        }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        annotation.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}

// MARK: LocationHandlerDelegate
extension AppleMapsViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        print(location)
    }
    
    func didFail(withError error: Error) {
        print(error)
    }
}

// MARK: UISearchBarDelegate
extension AppleMapsViewController: UISearchBarDelegate {
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

// MARK: AppleMapsPlaceViewModelProtocol
extension AppleMapsViewController: AppleMapsPlaceViewModelProtocol {
    func updateSearchCompleter(results: [MKLocalSearchCompletion]) {
        self.searchBar.text = results.first?.title
    }
    
    func addAnnotation(with annotation: MKAnnotation) {
        self.mapView.addAnnotation(annotation)
    }
    
    func removeAnnotation(with annotation: MKAnnotation) {
        self.mapView.removeAnnotation(annotation)
    }
}

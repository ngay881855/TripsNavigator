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
    
    // MARK: - Public properties
    var placeViewModel = AppleMapsPlaceViewModel()
    
    // MARK: - Private properties
    private lazy var locationHandler = LocationHandler(delegate: self)
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationHandler.getUserLocation()
        self.placeViewModel.delegate = self
      
        self.mapView.register(
          PlaceView.self,
          forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - Extensions
extension AppleMapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }

        var annotationView: MKAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceView") {
            annotationView = dequeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceView")
            annotationView.canShowCallout = true

            let scoreLabel = UILabel()
            scoreLabel.numberOfLines = 0
            scoreLabel.font = scoreLabel.font.withSize(12)
            scoreLabel.text = "Score: \(placeAnnotation.score) \nPopulation: \(placeAnnotation.population)"
            annotationView.detailCalloutAccessoryView = scoreLabel
        }

        return annotationView
    }
}

extension AppleMapsViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        print(location)
    }
    
    func didFail(withError error: Error) {
        print(error)
    }
}

// MARK: - Extensions
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

extension AppleMapsViewController: AppleMapsPlaceViewModelProtocol {
    func addAnnotation(with annotation: PlaceAnnotation) {
        self.mapView.addAnnotation(annotation)
    }
    
    func removeAnnotation(with annotation: PlaceAnnotation) {
        self.mapView.removeAnnotation(annotation)
    }
}

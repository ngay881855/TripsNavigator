//
//  LocationHandler.swift
//  Location_demo
//
//  Created by Ngay Vong on 10/16/20.
//

import UIKit
import Foundation
import CoreLocation

protocol LocationHandlerDelegate: AlertHandlerProtocol {
    func received(location: CLLocation)
    func didFail(withError error: Error)
}

class LocationHandler: NSObject {
    
    // MARK: - Private properties
    private lazy var locationManager: CLLocationManager = {
        let locationM = CLLocationManager()
        locationM.delegate = self
        locationM.desiredAccuracy = kCLLocationAccuracyBest // default value
        locationM.pausesLocationUpdatesAutomatically = true
        locationM.showsBackgroundLocationIndicator = true
        locationM.distanceFilter = 2.0 // distance in meter the device has to move horizontally before update event is generated
        return locationM
    }()
    
    private var delegate: LocationHandlerDelegate?
    
    var completion: ((Result<CLLocation, Error>) -> Void)?
    
    // MARK: - Initializers
    init(delegate: LocationHandlerDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    init(completion: ((Result<CLLocation, Error>) -> Void)?) {
        self.completion = completion
        super.init()
    }
    
    // MARK: - UISetup/Helpers/Actions
    private func checkAndPromptLocationAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        case .restricted, .denied:
            self.delegate?.showAlert(title: "Location Denied", message: "Please provide access to location", buttons: [.cancel, .settings]) { _, type in
                switch type {
                case .settings:
                    UIApplication.shared.openSetting()
                default:
                    break
                }
            }
        case .authorizedAlways, .authorizedWhenInUse:
            // Get user location
            self.locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func getUserLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.delegate?.showAlert(title: "Location disabled", message: "Please enable your location services", buttons: [.cancel, .settings]) { (_, type) in
                switch type {
                case .settings:
                    UIApplication.shared.openSetting()
                case .cancel:
                    print("cancel pressed")
                }
            }
            return
        }
        checkAndPromptLocationAuthorizationStatus()
    }
}

// MARK: - Extensions
extension LocationHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkAndPromptLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        //self.locationManager.stopUpdatingLocation()
        //self.delegate?.received(location: mostRecentLocation)
        self.completion?(.success(mostRecentLocation))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //self.delegate?.didFail(withError: error)
        self.completion?(.failure(error))
    }
}
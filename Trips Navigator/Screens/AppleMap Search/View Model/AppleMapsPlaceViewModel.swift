//
//  AppleMapsPlaceViewModel.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import Foundation
import MapKit

protocol AppleMapsPlaceViewModelProtocol: AnyObject {
    func addAnnotation(with annotation: PlaceAnnotation)
    func removeAnnotation(with annotation: PlaceAnnotation)
}

class AppleMapsPlaceViewModel {
    
    weak var delegate: AppleMapsPlaceViewModelProtocol?
    
    // MARK: - Private properties
    private var dataSource: [PlaceAnnotation] = []
    private var searchRequest = MKLocalSearch.Request()
    private var search: MKLocalSearch?
    private var searchOption = SearchOptions.fromAPI
    
    func configUrlRequest(with keyword: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: ProviderAPI.baseUrl) else { return nil }
        ProviderAPI.parameters[ProviderAPI.query] = keyword
        urlComponents.queryItems = ProviderAPI.parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = ProviderAPI.headers
        
        return urlRequest
    }
    
    func searchData(with keyword: String) {
        switch searchOption {
        case .fromAPI:
            searchFromAPI(with: keyword)
            
        case .fromLocal:
            searchFromLocal(with: keyword)
        }
    }
    
    private func removeAllAnnotations() {
        self.dataSource.forEach { annotation in
            self.delegate?.removeAnnotation(with: annotation)
        }
    }
    
    private func searchFromAPI(with keyword: String) {
        guard let urlRequest = configUrlRequest(with: keyword) else {
            return
        }
        
        removeAllAnnotations()
        
        self.dataSource.removeAll()
        
        ServiceManager.manager.request([Place].self, withRequest: urlRequest) { result in
            switch result {
            case .success(let cities):
                cities.forEach { self.dataSource.append(PlaceAnnotation(place: $0)) }
                DispatchQueue.main.async {
                    self.dataSource.forEach { annotation in
                        self.delegate?.addAnnotation(with: annotation)
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchFromLocal(with keyword: String) {
        searchRequest.naturalLanguageQuery = keyword
        
        if let search = self.search, search.isSearching {
            search.cancel()
            self.search = MKLocalSearch(request: searchRequest)
        } else {
            self.search = MKLocalSearch(request: searchRequest)
        }
        
        search?.start { response, error in
            guard let response = response else {
                print("Error \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            self.removeAllAnnotations()

            for item in response.mapItems {
                let coordinate = Coordinates(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                let place = Place(identifier: item.name ?? "", type: "", name: item.name ?? "", population: 0, score: 0, coordinates: coordinate)
                let placeAnnotation = PlaceAnnotation(place: place)
                self.dataSource.append(placeAnnotation)
            }
            DispatchQueue.main.async {
                self.dataSource.forEach { annotation in
                    self.delegate?.addAnnotation(with: annotation)
                }
            }
        }
    }
    
    func createAnnotationView(viewFor annotation: MKAnnotation, mapView: MKMapView) -> MKAnnotationView? {
        guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }
        
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(12)
        detailLabel.text = "Score: \(placeAnnotation.score) \nPopulation: \(placeAnnotation.population)"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceView") {
            annotationView.detailCalloutAccessoryView = detailLabel
            return annotationView
        } else {
            var annotationView: MKAnnotationView
            annotationView = MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: "PlaceView")
            annotationView.canShowCallout = true
            annotationView.detailCalloutAccessoryView = detailLabel
            
            return annotationView
        }
    }
}

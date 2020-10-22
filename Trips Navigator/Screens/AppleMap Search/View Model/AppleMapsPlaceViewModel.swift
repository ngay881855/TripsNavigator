//
//  AppleMapsPlaceViewModel.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import CoreLocation
import Foundation
import MapKit

protocol AppleMapsPlaceViewModelProtocol: AnyObject {
    func addAnnotation(with annotation: MKAnnotation)
    func removeAnnotation(with annotation: MKAnnotation)
    func updateSearchCompleter(results: [MKLocalSearchCompletion])
}

class AppleMapsPlaceViewModel: NSObject {
    
    weak var delegate: AppleMapsPlaceViewModelProtocol?
    
    // MARK: - Private properties
    private var dataSource: [MKAnnotation] = []
    private var searchRequest = MKLocalSearch.Request()
    private var search: MKLocalSearch?
    private var searchOption = SearchOptions.fromLocal
    private var searchCompleter = MKLocalSearchCompleter()
    private var geoCoder = CLGeocoder()
    
    var searchResults: [MKLocalSearchCompletion] = []
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        if geoCoder.isGeocoding {
            geoCoder.cancelGeocode()
        }
        geoCoder.geocodeAddressString("1 Infinite Loop, Cupertino, CA") { placeMarks, error in
            self.processGeoCoderResponse(withPlaceMarks: placeMarks, error: error)
        }
    }
    
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
        
        searchCompleter.queryFragment = keyword
        
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
        
        self.removeAllAnnotations()
        self.dataSource.removeAll()
        
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
            
            for item in response.mapItems {
                let placeAnnotation = LocalSearchAnnotation(mapItem: item)
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
        var annotationView: MKAnnotationView?
        if let placeAnnotation = annotation as? PlaceAnnotation {
            annotationView = self.createAPISearchAnnotationView(annotation: placeAnnotation, mapView: mapView)
        } else if let localSearchAnnotation = annotation as? LocalSearchAnnotation {
            annotationView = self.createLocalSearchAnnotationView(annotation: localSearchAnnotation, mapView: mapView)
        }
        
        return annotationView
    }
    
    private func createLocalSearchAnnotationView(annotation: LocalSearchAnnotation, mapView: MKMapView) -> MKAnnotationView? {
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.reuseIdentifier)
        if pin == nil {
            pin = CustomAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.reuseIdentifier)
        } else {
            pin?.annotation = annotation
        }
        pin?.image = annotation.image
        
        return pin
    }
    
    private func createAPISearchAnnotationView(annotation: PlaceAnnotation, mapView: MKMapView) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(12)
        detailLabel.text = "Score: \(annotation.score) \nPopulation: \(annotation.population)"
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PlaceAnnotationView.reuseIdentifier) {
            dequeuedAnnotationView.detailCalloutAccessoryView = detailLabel
            annotationView = dequeuedAnnotationView
        } else {
            var defaultAnnotationView: MKAnnotationView
            defaultAnnotationView = PlaceAnnotationView(annotation: annotation, reuseIdentifier: PlaceAnnotationView.reuseIdentifier)
            
            defaultAnnotationView.canShowCallout = true
            defaultAnnotationView.detailCalloutAccessoryView = detailLabel
            
            annotationView = defaultAnnotationView
        }
        
        annotationView?.image = annotation.image
        
        return annotationView
    }
}

extension AppleMapsPlaceViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.delegate?.updateSearchCompleter(results: searchResults)
    }
    
    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        print(error)
    }
}

extension AppleMapsPlaceViewModel {
    private func processGeoCoderResponse(withPlaceMarks placeMarks: [CLPlacemark]?, error: Error?) {
        if let placeMarks = placeMarks, !placeMarks.isEmpty {
            if let location = placeMarks.first?.location {
                geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
                    self.processReversedGeoCoderResponse(withPlaceMarks: placeMarks, error: error)
                }
                print("\(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
        } else {
            print("No result")
        }
    }
    
    private func processReversedGeoCoderResponse(withPlaceMarks placeMarks: [CLPlacemark]?, error: Error?) {
        if let placeMarks = placeMarks, !placeMarks.isEmpty {
            if let placeMark = placeMarks.first {
                print("\(String(describing: placeMark.name)), \(String(describing: placeMark.postalCode))")
            }
        } else {
            print("No result")
        }
    }
}

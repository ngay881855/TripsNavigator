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
    var dataSource: [PlaceAnnotation] = []
    
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
        guard let urlRequest = configUrlRequest(with: keyword) else {
            return
        }
        
        self.dataSource.forEach { annotation in
            self.delegate?.removeAnnotation(with: annotation)
        }
        
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
    
    func createMarker(with annotation: MKAnnotation) -> UIView? {
        guard let placeAnnotation = annotation as? PlaceAnnotation else {
            return nil
        }
        
        guard let infoView = UIView.viewFromNibName("PlaceAnnotationView") as? PlaceAnnotationView
        else {
            return nil
        }
        infoView.setupUI(withName: placeAnnotation.title ?? "", population: placeAnnotation.population, score: placeAnnotation.score)
        
        return infoView
    }
}

//
//  PlaceViewModel.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import Foundation
import GoogleMaps

protocol PlaceViewModelProtocol: class {
    func addGMSMarker(with marker: PlaceMarker)
}

class PlaceViewModel {
    
    var delegate: PlaceViewModelProtocol?
    
    // MARK: - Private properties
    var dataSource: [PlaceMarker] = []
    
    
    func configUrlRequest(with keyword: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: ProviderAPI.baseUrl) else { return nil }
        ProviderAPI.parameters[ProviderAPI.query] = keyword
        urlComponents.queryItems = ProviderAPI.parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else { return nil}
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = ProviderAPI.headers
        
        return urlRequest
    }
    
    func searchData(with keyword: String) {
        guard let urlRequest = configUrlRequest(with: keyword) else {
            return
        }
        ServiceManager.manager.request([Place].self, withRequest: urlRequest) { result in
            switch result {
            case .success(let cities):
                self.dataSource.removeAll()
                cities.forEach { self.dataSource.append(PlaceMarker(place: $0))}
                DispatchQueue.main.async {
                    self.dataSource.forEach { marker in
                        self.delegate?.addGMSMarker(with: marker)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

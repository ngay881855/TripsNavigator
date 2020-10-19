//
//  ServiceManager.swift
//  PhotoHunt
//
//  Created by Ngay Vong on 10/4/20.
//

import Foundation

enum CustomError: Error {
    case serverError
    case decodingFailed
}

class ServiceManager {
        
    static let manager = ServiceManager()
    
    private init() {}
    
    func request<T: Decodable>(_ type: T.Type, withRequest urlRequest: URLRequest, completion: @escaping (Result<T, CustomError>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
                    }
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(obj))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
            }
        }
        task.resume()
    }
}

//
//  Constants.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/18/20.
//

import Foundation

struct Constants {
    static let googleApiKey = "AIzaSyAmz_WWtx3xandmqLvN-2HWNXTRZ9l4mz4"
}

enum ProviderAPI {
    static let query: String = "q"
    static let baseUrl = "https://rapidapi.p.rapidapi.com/places"
    static var parameters = [query: "",
                             "country": "US,CA",
                             "skip": "0",
                             "limit": "100",
                             "type": "CITY"]
    static let headers = ["x-rapidapi-host": "spott.p.rapidapi.com",
                          "x-rapidapi-key": "e9e886cd17msh32062c46cf93125p1a1b79jsn312df2c8284f"]
}

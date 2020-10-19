//
//  Constants.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/18/20.
//

import Foundation

enum Constants {
    static let googleApiKey = "YOUR_API_KEY"
    static let timerIntervalToSearch = 1.0
}

enum ProviderAPI {
    static let query: String = "q"
    static let baseUrl = "https://rapidapi.p.rapidapi.com/places"
    static var parameters = [
        query: "",
        "country": "US,CA",
        "skip": "0",
        "limit": "100",
        "type": "CITY"
    ]
    static let headers = [
        "x-rapidapi-host": "spott.p.rapidapi.com",
        "x-rapidapi-key": "YOUR_API_KEY"
    ]
}

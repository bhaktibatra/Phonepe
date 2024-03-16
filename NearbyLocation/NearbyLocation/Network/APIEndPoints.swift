//
//  APIEndPoints.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import Foundation

enum APIEndPoints: String {
    case venueUrl = "https://api.seatgeek.com/2/venues"
}


enum NetworkError: Error {
    case invalidURL
    case apiError
    case parsingError
}

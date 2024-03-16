//
//  LocationListModel.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import Foundation

struct NearbyAttractionResponse: Codable {
    let response: AttractionModel
}

struct AttractionModel: Codable {
    let venues: [AttractionData]
}

struct AttractionData: Codable {
    let name: String
    let city: String?
    let address: String?
    let url: String?
}

struct QueryParams {
    
}

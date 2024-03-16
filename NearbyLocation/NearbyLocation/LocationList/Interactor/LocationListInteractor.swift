//
//  LocationListInteractor.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import Foundation

protocol LocationListInteractorProtocol {
    func fetchVenues(completion: @escaping (Result<[AttractionData], Error>) -> Void, parameters: [String:String])
}

class LocationListInteractor: LocationListInteractorProtocol {
    private let apiService: NetworkManagerProtocol
    
    init(apiService: NetworkManagerProtocol) {
        self.apiService = apiService
    }
    
    func fetchVenues(completion: @escaping (Result<[AttractionData], Error>) -> Void, parameters: [String:String]) {
        let queryParams: [String:String] = ["client_id": "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5",
                         "per_page": parameters["per_page"] ?? "",
                         "page":parameters["page"] ?? "",
                         "lat": parameters["lat"] ?? "",
                         "lon": parameters["lon"] ?? "",
                         "range": parameters["range"] ?? ""]
        apiService.fetchVenues(urlString: APIEndPoints.venueUrl.rawValue, parameters: queryParams, completion: { result in
            switch result {
                case .success(let venuesData):
                completion(.success(venuesData.venues))
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
}

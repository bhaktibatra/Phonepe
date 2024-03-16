//
//  NetworkManager.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchVenues(urlString: String, parameters: [String:String], completion: @escaping (Result<AttractionModel, Error>) -> Void)
}

class ApiService: NetworkManagerProtocol {
    func fetchVenues(urlString: String, parameters: [String:String], completion: @escaping (Result<AttractionModel, Error>) -> Void) {
        let queryParams = [
            URLQueryItem(name: "client_id", value: parameters["client_id"]),
            URLQueryItem(name: "per_page", value: parameters["per_page"]),
            URLQueryItem(name: "page", value: parameters["page"]),
            URLQueryItem(name: "lat", value: parameters["lat"]),
            URLQueryItem(name: "lon", value: parameters["lon"]),
            URLQueryItem(name: "range", value: parameters["range"]),
            URLQueryItem(name: "q", value: "ub")]
        guard var urlComponents = URLComponents(string: urlString) else {
                   completion(.failure(NetworkError.invalidURL))
                   return
        }
       urlComponents.queryItems = queryParams
       
       guard let url = urlComponents.url else {
           completion(.failure(NetworkError.invalidURL))
           return
       }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.apiError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let venuesData = try decoder.decode(AttractionModel.self, from: data)
                completion(.success(venuesData))
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(NetworkError.parsingError))
            }
        }
        task.resume()
    }
}



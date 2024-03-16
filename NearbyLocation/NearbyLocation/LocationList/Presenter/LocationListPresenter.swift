//
//  LocationListPresenter.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import Foundation

protocol LocationListPresenterProtocol: AnyObject {
    func fetchVenues(currentPage: Int, range: Int)
    func fetchNextPage()
}

protocol LocationListViewProtocol: AnyObject {
    func attractionsFetched(_ venues: [AttractionData])
    func showError(_ error: Error)
}

class LocationListPresenter: LocationListPresenterProtocol {
    private weak var view: LocationListViewProtocol?
    private let interactor: LocationListInteractorProtocol
    private var currentPage = 1
    private var lat: Double = 0
    private var lon: Double = 0
    
    init(interactor: LocationListInteractorProtocol, view: LocationListViewProtocol?) {
        self.interactor = interactor
        self.view = view
    }
    
    func fetchVenues(currentPage: Int, range: Int) {
        LocationManager.shared.requestLocation { coordinate, error in
            if let error = error {
                print("Error fetching location: \(error.localizedDescription)")
            } else if let coordinate = coordinate {
                print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                self.lat = coordinate.latitude
                self.lon = coordinate.longitude
                let parameters = ["per_page": "\(10)",
                                   "page": "\(1)",
                                  "lat": "\(coordinate.latitude)",
                                  "lon": "\(coordinate.longitude)",
                                   "range": "12mi"]
                self.interactor.fetchVenues(completion: { [weak self] result in
                    switch result {
                       case .success(let venues):
                           self?.view?.attractionsFetched(venues)
                       case .failure(let error):
                           self?.view?.showError(error)
                    }
                }, parameters: parameters)
            }
        }
    }
    
    func fetchNextPage() {
        currentPage += 1
        let parameters = ["per_page": "\(10)",
                           "page": "\(currentPage)",
                          "lat": "\(lat)",
                          "lon": "\(lon)",
                           "range": "12mi"]
        self.interactor.fetchVenues(completion: { [weak self] result in
            switch result {
               case .success(let venues):
                   self?.view?.attractionsFetched(venues)
               case .failure(let error):
                   self?.view?.showError(error)
            }
        }, parameters: parameters)
    }
}

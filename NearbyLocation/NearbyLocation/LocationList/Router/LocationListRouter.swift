//
//  LocationListRouter.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import UIKit

class VenueListRouter {
    static func createModule() -> UIViewController {
        let viewController = ViewController()
        let interactor = LocationListInteractor(apiService: ApiService())
        let presenter = LocationListPresenter(interactor: interactor, view: viewController)
        
        viewController.presenter = presenter
        return viewController
    }
}

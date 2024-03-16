//
//  LocationListViewController.swift
//  Nearby
//
//  Created by Bhakti Batra on 16/03/24.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    var presenter: LocationListPresenterProtocol?
    private var tableView: UITableView!
    private var venues: [AttractionData] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        presenter?.fetchVenues(currentPage: 0, range: 100)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VenueCell.self, forCellReuseIdentifier: VenueCell.reuseIdentifier)
        tableView.isUserInteractionEnabled = true
        view.addSubview(tableView)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueCell.reuseIdentifier, for: indexPath) as! VenueCell
        let venue = venues[indexPath.row]
        cell.configure(with: venue)
        cell.urlTappedHandler = {
            if let urlString = venue.url, let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter?.fetchNextPage()
        }
    }
}

extension ViewController: LocationListViewProtocol {
    func attractionsFetched(_ venues: [AttractionData]) {
        self.venues = venues
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideActivityIndicator()
        }
    }
    
    func showError(_ error: Error) {
        // Handle error
    }
}

extension ViewController {
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

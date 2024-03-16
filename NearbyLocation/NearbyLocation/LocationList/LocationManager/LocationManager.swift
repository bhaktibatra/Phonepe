//
//  LocationManager.swift
//  NearbyLocation
//
//  Created by Bhakti Batra on 16/03/24.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D?, Error?) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.completion = completion
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        } else {
            completion(nil, NSError(domain: "LocationServicesDisabled", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services are disabled"]))
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            completion?(nil, NSError(domain: "NoLocationAvailable", code: 0, userInfo: [NSLocalizedDescriptionKey: "No location available"]))
            return
        }
        completion?(location.coordinate, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil, error)
    }
}

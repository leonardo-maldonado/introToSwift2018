//
//  MapViewController.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/24/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CrimeRepository.shared.getAllRemote { (crimes, error) in
            guard let crimes = crimes else { return }
            for crime in crimes {
                // Drop a pin at crime location's
                guard let lat = crime.location?.coordinates[1] else { return }
                guard let long = crime.location?.coordinates[0] else { return }
                let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                myAnnotation.coordinate = CLLocationCoordinate2DMake(lat, long);
                self.mapView.addAnnotation(myAnnotation)
            }
        }

        determineCurrentLocation()
        setupMapView()
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func setupMapView() {
        mapView.showsUserLocation = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        /// Call stopUpdatingLocation() to stop listening for location
        /// updates, other wise this function will be called every
        /// time when user location changes.
        manager.stopUpdatingLocation()
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let center = CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

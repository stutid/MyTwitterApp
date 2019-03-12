//
//  MapViewController.swift
//  MyTwitterApp
//
//  Created by admin on 17/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let viewModel = ViewModel()
    var previousLocation: CLLocation?
    var isEnded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = .mutedStandard
        mapView.register(TweetAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        viewModel.delegate = self
        setupLocation()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap(_:)))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension MapViewController: ViewModelDelegate {
    
    func showAnnotationForTweet(_ tweet: Tweet) {
        if tweet.coordinate != nil {
            let point = TweetAnnotation()
            point.coordinate = tweet.coordinate!
            point.screenName = tweet.user.screenName
            point.userName = tweet.user.name
            point.tweet = tweet.tweetText
            self.mapView.addAnnotation(point)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            viewModel.setLocation(lat: myLocation.latitude, lon: myLocation.longitude)
            setMapRegion(for: myLocation)
            previousLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func setMapRegion(for myLocation: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didDragMap(_ gestureRecognizer: UIPanGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            if previousLocation != nil {
                let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                let distance = previousLocation!.distance(from: location)
                
                if distance > 2000 {
                    self.viewModel.setLocation(lat: self.mapView.centerCoordinate.latitude, lon: self.mapView.centerCoordinate.longitude)
                    previousLocation = location
                }
            }
        }
       
    }
}

//
//  detailsViewController.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business!
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = YelpRedColor.getYelpRedColor()
        
        // load data
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        if business.imageURL != nil {
            thumbImageView.setImageWith(business.imageURL!)
        } else {
            thumbImageView.image = UIImage(named: "blank")
        }
        nameLabel.text = business.name!
        distanceLabel.text = business.distance!
        categoriesLabel.text = business.categories!
        addressLabel.text = business.address!
        reviewsLabel.text = "\(business.reviewCount!) Reviews"
        ratingsImageView.setImageWith(business.ratingImageURL!)
        
        // setup Map
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        addAnnotationAtAddress(address: addressLabel.text!)
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.025, 0.025)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.025, 0.025)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotationAtAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = self.nameLabel.text
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
}



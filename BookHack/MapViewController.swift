//
//  MapViewController.swift
//  BookHack
//
//  Created by Andrea Vitek on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    fileprivate var span: CLLocationDegrees{
        return mapView.region.span.latitudeDelta * 111 * 1000
    }
    
    fileprivate var currentMapCenter: CLLocation {
        return CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    func centerOnUserLocation(animated: Bool) {
        if let userLocation = mapView.userLocation.location {
            let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.gray
    }
    
    func instantiateController(withCenter center: CLLocation?) {
        var location: CLLocation
        
        if center != nil {
            location = center!
        } else {
            location = mapView.userLocation.location!
        }
        
        let searchDistance:Double =  5.00 //float value in KM
        
        let minLat = mapView.userLocation.coordinate.latitude - (searchDistance / 69)
        let maxLat = mapView.userLocation.coordinate.latitude + (searchDistance / 69)
        
        let minLon = mapView.userLocation.coordinate.longitude - searchDistance / fabs(cos(deg2rad(degrees: location.coordinate.latitude))*69)
        let maxLon = mapView.userLocation.coordinate.longitude + searchDistance / fabs(cos(deg2rad(degrees: location.coordinate.latitude))*69)
        
        ConnectionHandler.sharedInstance.findBooksWithin(maxLat: maxLat, minLat: minLat, maxLon: maxLon, minLon: minLon) { (done, results) in
            print("\(maxLat)   \((minLat))")
            print("\(maxLon)   \((minLon))")
        
            print("Found \(results.count) books")
            
            var annotation = [MKAnnotation]()
            
            for i in results {
                print(i)
            
                let obj =  Book(names: i["bookname"] as! String, auth: i["author"] as! String, ISBNs: i["ISBN"] as! Int, urls: i["url"] as! String, created: i["createdAt"] as! Date, longitude: i["longitude"] as! Float, latitude: i["latitude"] as! Float, seller: i["seller"] as! String, condition: i["condition"] as! String, price: i["price"] as! Double)
                
                annotation.append(obj)
                self.mapView.addAnnotation(obj)
            }
            
            self.mapView.showAnnotations(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation as MKAnnotation) {
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "pin.png")
        
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            centerOnUserLocation(animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerOnUserLocation(animated: true)
        instantiateController(withCenter: nil)
    }
    
    private func deg2rad(degrees:Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    @IBAction func getNearbyBooks(_ sender: UIButton) {
        instantiateController(withCenter: currentMapCenter)
    }
    
    @IBAction func centerLocationButtonPressed(_ sender: UIButton) {
        centerOnUserLocation(animated: true)
        instantiateController(withCenter: nil)
    }
}

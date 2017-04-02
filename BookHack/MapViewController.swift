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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let reuseID = "KoobBookAnnotationView"
    var locationManager: CLLocationManager!
    
    fileprivate var span: CLLocationDegrees{
        return mapView.region.span.latitudeDelta * 111 * 1000
    }
    
    fileprivate var currentMapCenter: CLLocation {
        return CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
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
    
    func instantiateController() {
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ConnectionHandler.dataType)
//        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        
        let searchDistance:Double =  5.00 //float value in KM
        
        let minLat = mapView.userLocation.coordinate.latitude - (searchDistance / 69)
        let maxLat = mapView.userLocation.coordinate.latitude + (searchDistance / 69)
        
        let minLon = mapView.userLocation.coordinate.longitude - searchDistance / fabs(cos(deg2rad(degrees: mapView.userLocation.coordinate.latitude))*69)
        let maxLon = mapView.userLocation.coordinate.longitude + searchDistance / fabs(cos(deg2rad(degrees: mapView.userLocation.coordinate.latitude))*69)
        
        ConnectionHandler.sharedInstance.findBooksWithin(maxLat: maxLat, minLat: minLat, maxLon: maxLon, minLon: minLon) { (done, results) in
            
            print("\(maxLat)   \((minLat))")
            print("\(maxLon)   \((minLon))")

        
            print("Found \(results.count) books")
            for i in results
            {
                print(i["bookname"] as! String)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerOnUserLocation(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            centerOnUserLocation(animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerOnUserLocation(animated: true)
    }
    
    func getNearbyBooks() {
        // show only non-completed items
        var error : NSError? = nil
        do {
            try fetchedResultController?.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
            abort()
            
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo:
        NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async(execute: { () -> Void in
            print(controller.fetchedObjects ?? "Nothing fetched")
        })
    }
    
    

    
    private func deg2rad(degrees:Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    @IBAction func getNearbyBooks(_ sender: UIButton) {
        instantiateController()
    }
    
    @IBAction func centerLocationButtonPressed(_ sender: UIButton) {
        centerOnUserLocation(animated: true)
    }
}

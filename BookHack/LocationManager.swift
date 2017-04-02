//
//  LocationManager.swift
//  BookHack
//
//  Created by Andrea Vitek on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: CLLocationManager {
    static let sharedInstance = LocationManager()
    
    var userLocation: CLLocation? {
        get {
            return askForAuthorization()
        }
    }
    
    override init() {
        super.init()
        self.requestWhenInUseAuthorization()
        desiredAccuracy = kCLLocationAccuracyBest
        startUpdatingLocation()
    }

    
    fileprivate func askForAuthorization() -> CLLocation? {
        self.requestAlwaysAuthorization()
        
        return location
    }
}

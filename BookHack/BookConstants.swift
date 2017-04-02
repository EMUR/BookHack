//
//  BookConstants.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import Foundation
import MapKit

class Book: NSObject, MKAnnotation {
    init(names:String!, auth:String!, ISBNs:Int!, urls:String!, created:Date!, longitude:Float, latitude:Float) {
        name = names
        author = auth
        ISBN = ISBNs
        url = urls
        createdAt = created
        long = longitude
        lat = latitude
        
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        }
        
        set (coordinate) {
            lat = Float(coordinate.latitude)
            long = Float(coordinate.longitude)
        }
    }
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    var radius: Double?
    var title: String?
    var subtitle: String?
    
    var name:String!
    var author:String!
    var ISBN:Int!
    var url:String!
    var createdAt:Date!
    var long:Float
    var lat:Float
}

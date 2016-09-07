//
//  NorthPole.swift
//  FavoritePlaces
//
//  Created by Sourabh Deshkulkarni on 4/1/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class NorthPole:NSObject, MKAnnotation {
    var point = MKPointAnnotation()

    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 30000, 30000)
        print("I am in mapView")
        mapView.setRegion(mkCoordinateRegion, animated: true)
        //Add annotation
        let point = MKPointAnnotation()
        point.coordinate = userLocation.coordinate
        point.title = "Where am I ?"
        point.subtitle = "I am here"
        mapView.addAnnotation(point)
    }
    
    //Needed for MKAnnotation Protocol
    @objc var coordinate:CLLocationCoordinate2D{
        get{
            return point.coordinate
        }
    }
    
    @objc var title:String?{
        return "The North Pole"
    }
    @objc var subtitle:String?{
    return "Santa's Workshop"
    }
    
    
}

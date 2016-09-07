//  FavoritePlaces
//
//  Created by Bryan French on 7/31/15.
//  Copyright (c) 2015 Bryan French. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate,ZoomingProtocol {
      @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView : MKMapView!
       var locationManager: CLLocationManager?
    var parkList = Parks()
    
    var parks : [Park] {
        get {
            return self.parkList.parkList!
        }
        set(val) {
            self.parkList.parkList = val
        }
    }
    func zoomOnAnnotation(annotation:MKAnnotation){
        tabBarController?.selectedViewController = self
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250,250)
                mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    @IBAction func zoomOut(sender: AnyObject) {
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

    }
    

    func mapView(manager: CLLocationManager!, didUpdateLocations userLocation: MKUserLocation) {
        self.activityIndicator.hidden = true;
            
            mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
            let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 20, 20)
            mapView.setRegion(mkCoordinateRegion, animated: true)
       // let currentLocation = locationManager!.location!.coordinate
     
        
    }
    @IBAction func zoomIn(sender: AnyObject) {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        if let lat = locationManager!.location?.coordinate.latitude,
            lon = locationManager!.location?.coordinate.latitude {
let currentLocation = locationManager!.location?.coordinate
        
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
       
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocation!, span)
        
        mapView.setRegion(region, animated: false)
    }
    }
    
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation
        print("The title of the annotation is: \(annotation!.title)")
        //Find Current location.
        let currentLocation = locationManager!.location!.coordinate
       
        
        //Code to find the directions between source and destination
        let directionRequest = MKDirectionsRequest()
        self.activityIndicator.hidden = true;
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude), addressDictionary: nil))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: annotation!.coordinate.latitude, longitude: (annotation?.coordinate.longitude)!), addressDictionary: nil))
        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = .Automobile
        
        let directionsToDestination = MKDirections(request: directionRequest)
        
        directionsToDestination.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    //Called once for wach annotation created - if no view returned
    //use the default
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        let identifier = "Pin"
        
        if annotation is MKUserLocation{
            return nil
        }
        self.activityIndicator.hidden = true;
        if annotation !== mapView.userLocation{
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
                dequedView.annotation = annotation
                view = dequedView
                
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = MKPinAnnotationView.purplePinColor()
                view.animatesDrop = true
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let leftButton = UIButton(type: .InfoLight)
                let rightButton = UIButton(type: .DetailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
            }
            return view
        }
        return nil
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Control tapped: \(control), tag number = \(control.tag)")
        
        
        let parkAnnotation = view.annotation as! Park
        
        switch control.tag {
            
        case 0: //left button
            
            if let url = NSURL(string: parkAnnotation.getLink()){
                self.activityIndicator.hidden = false;
                self.activityIndicator.startAnimating()
                UIApplication.sharedApplication().openURL(url)
                
            }
            
        case 1: //right button
            
            let coordinate = locationManager!.location!.coordinate
            
            let url = String(format: "http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f", coordinate.latitude,coordinate.longitude,parkAnnotation.getLocation()!.coordinate.latitude,parkAnnotation.getLocation()!.coordinate.longitude)
            self.activityIndicator.hidden = false;
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            
        default:
            
            break
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        
        self.activityIndicator.hidden = true;
        for park: MKAnnotation in parks {
            mapView.addAnnotation(park)
        }
       
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.showsUserLocation = true
       
        super.viewDidLoad()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlayObject: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlayObject as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        self.activityIndicator.hidden = true;
        return renderer
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


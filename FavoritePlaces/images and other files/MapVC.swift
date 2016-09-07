//  FavoritePlaces
//
//  Created by Bryan French on 7/31/15.
//  Copyright (c) 2015 Bryan French. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView : MKMapView!
    var landmarkList = Landmarks()
    var landmarks : [Landmark] { //front end for LandmarkList model object
        get {
            return self.landmarkList.landmarkList!
        }
        set(val) {
            self.landmarkList.landmarkList = val
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for landmark: MKAnnotation in landmarks {
            mapView.addAnnotation(landmark)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


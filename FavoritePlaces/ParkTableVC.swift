//
//  ParkTableVC.swift
//  FavoritePlacesNPF
//
//  Created by Sourabh Deshkulkarni on 4/23/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation

class ParkTableVC: UITableViewController,CLLocationManagerDelegate {
    var mapVC:MapVC!
    //@IBOutlet segmentedControl
    var parkList = Parks()
     var locationManager: CLLocationManager?
    var parks : [Park] { //front end for LandmarkList model object
        get {
            return self.parkList.parkList!
        }
        set(val) {
            self.parkList.parkList = val
        }
    }
    
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentAction(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("first segement clicked")
            parks.sortInPlace({$0.getParkName() < $1.getParkName()})
            tableView.reloadData()
        case 1:
            print("second segment clicked")
            parks.sortInPlace({$0.getParkName() > $1.getParkName()})
            tableView.reloadData()
        
        case 2:
            print("third segment clicked")

            parks.sortInPlace({$0.getDistanceFromCurrentLocation() < $1.getDistanceFromCurrentLocation()})
            tableView.reloadData()
        default:
            break;
        }
    }
    override func viewWillAppear(animated: Bool) {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        if let lat = locationManager!.location?.coordinate.latitude,
            lon = locationManager!.location?.coordinate.latitude {
            print("\(lat) /// \(lon)")
            
            for i in 0 ..< parks.count  {
                let mainLocation = parks[i].getLocation()
                let location = CLLocation(latitude: lat, longitude: lon)
                
                let distance = location.distanceFromLocation(mainLocation!) / 1000
                print("distance: \(distance)")
                parks[i].setDistanceFromCurrentLocation(distance);
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParkCell", forIndexPath: indexPath)
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
       
       // let currentLocation = locationManager!.location!.coordinate
        //My location
//        let myLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        //My buddy's location
        //var parkLocation = CLLocation(latitude: 59.326354, longitude: 18.072310)
        
        //Measuring my distance to my buddy's (in km)
        
        
        //Display the result in km
       // println(String(format: "The distance to my buddy is %.01fkm", distance))
        
        // Configure the cell...
        let park = parks[indexPath.row]
//        let parkLocation = park.getLocation()
//        let distance = myLocation.distanceFromLocation(parkLocation!) / 1000
        cell.textLabel?.text = park.getParkName()
        //park.setDistanceFromCurrentLocation(distance)
        cell.detailTextLabel?.text = "\(park.getDistanceFromCurrentLocation())"
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let park = parks[indexPath.row]
        let detailVC = ParkTableDetailVC(style: .Grouped)
        detailVC.title = park.title
        detailVC.park = park
        detailVC.zoomDelegate = mapVC
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    

}

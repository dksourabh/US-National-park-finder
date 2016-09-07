//
//  FavoriteTableVC.swift
//  FavoritePlacesNPF
//
//  Created by Sourabh Deshkulkarni on 4/24/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit

class FavoriteTableVC: UITableViewController {
    var mapVC:MapVC!
    var parkList = Parks()
    var favArray:[String] = []
   // var locationManager: CLLocationManager?
    var parks : [Park] { //front end for LandmarkList model object
        get {
            return self.parkList.parkList!
        }
        set(val) {
            self.parkList.parkList = val
        }
    }
    override func viewWillAppear(animated: Bool) {
        let array = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]
        if(array != nil){
            self.favArray = array!
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    
        
        
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
        // let array = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]
        return (favArray.count)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath)
               //My buddy's location
        //var parkLocation = CLLocation(latitude: 59.326354, longitude: 18.072310)
        
        //Measuring my distance to my buddy's (in km)
        
        
        //Display the result in km
        // println(String(format: "The distance to my buddy is %.01fkm", distance))
        
        // Configure the cell...
       // let park = array![indexPath.row]
       // let parkLocation = park.getLocation()
        //let distance = myLocation.distanceFromLocation(parkLocation!) / 1000
       //print(array)
        cell.textLabel?.text = favArray[indexPath.row]
        
       // cell.detailTextLabel?.text = "\(distance)"
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
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            favArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

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
        let favoriteParkName = favArray[indexPath.row];
        var arrayIndex = 0
        for var i = 0; i < parks.count ; ++i {
            let parkName = parks[i].getParkName()
            if parkName == favoriteParkName {
                arrayIndex = i
            }
            
        }

        let park = parks[arrayIndex]
        let detailVC = ParkTableDetailVC(style: .Grouped)
        detailVC.title = park.title
        detailVC.park = park
        detailVC.zoomDelegate = mapVC
        navigationController?.pushViewController(detailVC, animated: true)
        
    }


}

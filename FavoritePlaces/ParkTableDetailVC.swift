//
//  ParkTableDetailVC.swift
//  FavoritePlacesNPF
//
//  Created by Sourabh Deshkulkarni on 4/23/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//
//var image : UIImage = UIImage(named: "osx_design_view_messages")
//println("The loaded image: \(image)")
//cell.imageView.image = image


import UIKit
let LANDMARK_SECTION = 0
let SHOW_ON_MAP = 2
let ADD_TO_FAVORITES = 3
let WIKI_URL = 4
let DESCRIPTION_SECTION = 1
let IMAGE_SECTION = 5
var favoriteArray: [String] = []


class ParkTableDetailVC: UITableViewController {
var park:Park!
    var zoomDelegate:ZoomingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //var
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == DESCRIPTION_SECTION {
            return 88.0
        }
        else if indexPath.section == IMAGE_SECTION{
            return 88.0
        }else{
            return 44.0
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 4
        }else{
        return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //doing programatically instead of vis storyboard.
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier:"resuseIdentifier")
        }
        switch indexPath.section {
        case LANDMARK_SECTION:
            let data = [park.getParkName(), park.getParkLocation(), park.getArea(), park.getDateFormed()]
            cell!.textLabel?.text = data[indexPath.row]
            
        case DESCRIPTION_SECTION:
            cell!.textLabel?.text = park.getParkDescription()
             cell!.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell?.textLabel?.numberOfLines = 10
        case SHOW_ON_MAP:
            cell!.textLabel?.text = "SHOW ON MAP"
        case ADD_TO_FAVORITES:
            cell!.textLabel?.text = "ADD TO FAVORITES"
        case WIKI_URL:
            cell!.textLabel?.text = park.getLink()
        case IMAGE_SECTION:
           // var image : UIImage = UIImage(named: "osx_design_view_messages")!
           // println("The loaded image: \(image)")
            let url = NSURL(string: park.getImageLink())
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            //let image = UIImage(named: park.getImageLink())
            cell!.textLabel?.textAlignment = .Center
            cell!.imageView!.image = image
        default:
            break
        }
        // Configure the cell...
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case LANDMARK_SECTION:
            title = "Park Details"
        case DESCRIPTION_SECTION:
            title = "Park Description"
        default:
            break
        }
        return title
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var msg = ""
               switch indexPath.section {
        case LANDMARK_SECTION:
            msg = "You tapped Landmark Name"
        case DESCRIPTION_SECTION:
            msg = "You tapped Landmark State"
        case SHOW_ON_MAP:
            msg = "You tapped Landmark Coordinates"
            //the worst way first
            //Get AppDelegate
            //            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate;
            //            (appDel.tabBarController?.viewControllers![0] as! MapVC).zoomOnAnnotation(landmark)
            // (tabBarController?.viewControllers![0] as! MapVC).zoomOnAnnotation(landmark)
            //   mapVC.zoomOnAnnotation(landmark)
            
            zoomDelegate?.zoomOnAnnotation(park)
        case WIKI_URL:
            if let url = NSURL(string: park.getLink()){
                
                UIApplication.sharedApplication().openURL(url)
            }
            
        case ADD_TO_FAVORITES:
            let alert = UIAlertController(title: "Added to Favorites", message: msg, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            presentViewController(alert, animated: true, completion: nil)
            let f = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]
            if(f != nil) {
                 favoriteArray = f!
            } else {
                favoriteArray = []
            }
           
         
            //NSUserDefaults.standardUserDefaults().setObject(favoriteArray, forKey: "favorites")
           // if favoriteArray != nil {
                //Swift 2: array.contains(park.getParkName())
                if !favoriteArray.contains(park.getParkName()) {
                favoriteArray.append(park.getParkName())
            }
               // }
//            } else {
//                favoriteArray = []
//            }
            NSUserDefaults.standardUserDefaults().setObject(favoriteArray, forKey: "favorites")
            //park.setIsFavorite("Yes")
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

}

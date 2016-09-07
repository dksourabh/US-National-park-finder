//
//  AppDelegate.swift
//  FavoritePlaces
//
//  Created by Sourabh Deshkulkarni on 3/30/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController:UITabBarController?
    var parks : [Park] = []
    
    
   
    
    func loadData(){

        
     
        
        if let path = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
          if let tempDict = NSDictionary(contentsOfFile: path){
            let tempArray = (tempDict.valueForKey("parks") as! NSArray) as Array
            for dict in tempArray {
                
                let parkName = dict["parkName"]! as! String
                
                let parkLocation = dict["parkLocation"]! as! String
                
                let latitude = (dict["latitude"]! as! NSString).doubleValue
                
                let longitude = (dict["longitude"]! as! NSString).doubleValue
                let area = dict["area"]! as! String
                let imageLink = dict["imageLink"]! as! String
                let dateFormed = dict["dateFormed"]! as! String
                let link = dict["link"]! as! String
                let description = dict["description"]! as! String
                let imageName = dict["imageName"]! as! String
                let imageSize = dict["imageSize"]! as! String
                let imageType = dict["imageType"]! as! String
                //let distanceFromCurrentLocation = 0.0
                
              let location = CLLocation(latitude: latitude, longitude: longitude)
//               // let parkLocation = park.getLocation()
//                let distance = myLocation!.distanceFromLocation(location) / 1000

                
                let p = Park(parkName: parkName, parkLocation: parkLocation, dateFormed: dateFormed, area: area,imageLink: imageLink,  location: location,  parkDescription: description,link: link,imageName:imageName,imageSize:imageSize,imageType:imageType,distanceFromCurrentLocation:0.0)
                parks.append(p)
                }
            }
            
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        loadData()


       
        tabBarController = self.window?.rootViewController as?
        UITabBarController
        let mapVC = tabBarController!.viewControllers![0] as! MapVC
        mapVC.parks = parks
        
        
        let navVC = tabBarController!.viewControllers![1] as! UINavigationController
        let tableVC = navVC.viewControllers[0] as! ParkTableVC
        
        
        tableVC.parks = parks
        tableVC.mapVC = mapVC
        
        let navVCOne = tabBarController!.viewControllers![3] as! UINavigationController
        let tableVCOne = navVCOne.viewControllers[0] as! FavoriteTableVC
        
        
        tableVCOne.parks = parks
        tableVCOne.mapVC = mapVC
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


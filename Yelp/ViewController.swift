//
//  ViewController.swift
//  Yelp
//
//  Created by Aditya Jayaraman
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UITableViewController, FiltersViewControllerDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    var client: YelpClient!
    var businessesArray: NSMutableArray!
    var locationManager : CLLocationManager?
    var location: CLLocationCoordinate2D?
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "O3oZPwddLQgm_9jUPBL1uw"
    let yelpConsumerSecret = "xfn0BFS6q4HUrr2ETKHgX_Aga7Y"
    let yelpToken = "3_wSBTT04b-1Fb5UtfoTSuFT1-8u1tdU"
    let yelpTokenSecret = "PotBKvuDUAjuhLsF8C6g3--Bz0o"
    
    //filters
    var categoryFilter : NSMutableSet?
    var sort : Int?
    var radius : Int?
    var deals : Bool?
    
    //limit and offset
    var limit : Int?
    var offset : Int?
    
    //search Bar
    var searchBar : UISearchBar?
    
    //reset businesses array
    var resetArray : Bool?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //filter button
        var filterButton = UIBarButtonItem(title: "Filter", style: .Bordered, target: self, action: "onFilter")
        filterButton.tintColor = UIColor.redColor()
        navigationItem.leftBarButtonItem = filterButton
        
        //search bar
        self.searchBar = UISearchBar(frame :CGRectMake(0, 0, 320, 64))
        self.searchBar!.center = CGPointMake(160, 284)
        self.searchBar!.delegate = self
        navigationItem.titleView = searchBar
        
        //map view
        //filter button
        var mapButton = UIBarButtonItem(title: "Map", style: .Bordered, target: self, action: "onMap")
        mapButton.tintColor = UIColor.redColor()
        navigationItem.rightBarButtonItem = mapButton
        
        //nav bar
        navigationItem.title = "Yelp"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
      
        //set filters to defaults
        self.categoryFilter = NSMutableSet()
        self.radius = -1
        self.sort = -1
        self.deals = false
        self.limit = 20
        self.offset = 0
        
        //clear defaults
        NSUserDefaults.standardUserDefaults().removeObjectForKey("filtersDict")
        
        //init array
        self.businessesArray = NSMutableArray()
        self.resetArray = false
        
        //get location
        self.locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        self.locationManager!.requestAlwaysAuthorization()
        
        // For use in foreground    
        self.locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager!.delegate = self
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager!.startUpdatingLocation()
        }
        
        //yelp client
        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }

    func reload(search: String = "") {
        println("reload")
        
        var parameters =  buildParameters(search)
        self.client.searchWithParameters(parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            if let r = response as? NSMutableDictionary {
                //println(r)
                if (self.resetArray!) {
                    var arr = r["businesses"] as NSArray
                    var marr = NSMutableArray(array: arr, copyItems: true)
                    self.businessesArray! = marr
                    self.resetArray! = false
                } else {
                var arr  = r["businesses"] as NSArray
                var marr = NSMutableArray(array: arr, copyItems: true)
                self.businessesArray!.addObjectsFromArray(marr)
                }
                self.tableView.reloadData()
            }
        
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    
    }
    
    //func buildParameters() -> Array<Dictionary<String,String>> {
    func buildParameters(search : String) -> Dictionary<String,String> {
  
        var default_params = ["limit" : self.limit!.description, "offset" : self.offset!.description, "ll": "\(location!.latitude),\(location!.longitude)"]
        var filtered_params = default_params

        //category filter
        var cf = ""
        for cat in self.categoryFilter! {
            cf += (cat as String) + ","
        }
        if cf != "" {
            cf = dropLast(cf)
            filtered_params["category_filter"] = cf
        }
        
        //sort
        if self.sort! != -1 {
            filtered_params["sort"] = String(self.sort!)
        }
        
        //radius
        if self.radius! != -1 {
            filtered_params["radius"] = String(self.radius!)
        }
        
        //deals
        if (self.deals!)  {
            filtered_params["deals"] = "true"
        }
        
        //search
        if (search != "") {
            filtered_params["term"] = search
        }
        
        //no filters, use a default term
        if (default_params == filtered_params) {
            filtered_params["term"] = "Restaurants"
        }
      
        println(filtered_params)
        return filtered_params
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println("cellForRowAtIndexPath")
        var business = self.businessesArray![indexPath.row] as NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier("codepath.mycell") as BusinessCell
        cell.initCellFromBusinessDictionary(business)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Did tap row \(indexPath.row)")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("numberOfRowsInSection")
        if let array = self.businessesArray {
            return array.count
        } else {
            return 0
        }
    }
    
    func onFilter() {
        var fvc = self.storyboard?.instantiateViewControllerWithIdentifier("fvc") as? FiltersViewController
        fvc?.delegate = self
        let navigationController = UINavigationController(rootViewController: fvc!)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func didChangeFilters(sender: FiltersViewController, value: Dictionary<String, Int>) {
        println("Did change filters \(value)")
        reset()
        
        for key in value.keys {
            //check for category match
            var cats = Category()
            for cat in 0...(cats.count() - 1) {
                if let c = cats.category[cat][key] {
                    if value[key]! == 1 {
                        self.categoryFilter?.addObject(c)
                    } else {
                        self.categoryFilter?.removeObject(c)
                    }
                }
            }
            
            //check for sort match
            if key == "Sort" {
                self.sort = value[key]
            }
            
            //check for distance match
            if key == "Distance" {
                self.radius = Distance().distance[value[key]!]
            }
            
            //check for deals match
            if key == "Deals" {
                if value[key] == 1 {
                    self.deals = true
                } else {
                    self.deals = false
                }
            }
        }
        reload()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
        self.location = locValue
        self.locationManager!.stopUpdatingLocation()
        reload()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Failed to update location : \(error)")
        self.locationManager!.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("auth changed")
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        reset()
        self.tableView.endEditing(true)
        reload(search : self.searchBar!.text)
    }
    
    func onMap() {
        println("Map")
        var mvc = self.storyboard?.instantiateViewControllerWithIdentifier("mvc") as? MapViewController
        mvc?.userLocation = Location(location : self.location!, title : "Home")
        mvc!.locationsToPin = locationFromBusinesses()
        let navigationController = UINavigationController(rootViewController: mvc!)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    func locationFromBusinesses() -> Array<Location> {
        var arr = Array<Location>()
        for business in self.businessesArray {
            if let loc = ((business as NSDictionary)["location"] as? NSDictionary) {
                if let coordinates = loc["coordinate"] as? NSDictionary {
                    let lat = coordinates["latitude"] as Double
                    let long = coordinates["longitude"] as Double
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    arr.append(Location(location: location, title: business["name"] as NSString))
                }
            }
        }
        return arr
    }
    
    //infinite scroll
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == (self.businessesArray!.count - 1)) && (self.offset < 1000) {
            self.offset! += 20
            reload()
        }
    }
    
    func reset() {
        self.offset! = 0
        self.resetArray! = true
    }
}


//
//  MapViewController.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {


    @IBOutlet weak var mapView: MKMapView!
    var userLocation : Location?
    var locationsToPin : Array<Location>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var cancelButton = UIBarButtonItem(title: "Back", style: .Bordered, target: self, action: "onBack")
        cancelButton.tintColor = UIColor.redColor()
        navigationItem.leftBarButtonItem = cancelButton
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Yelp"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
       
        //region center on map
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: userLocation!.location!, span: span)
        mapView.setRegion(region, animated: true)
        
        //3 pin the userLocation
        let userAnnotation = MKPointAnnotation()
        userAnnotation.setCoordinate(userLocation!.location!)
        userAnnotation.title = userLocation!.title
        mapView.addAnnotation(userAnnotation)
        
        //4 pin the rest of the locations
        for loc in self.locationsToPin! {
            let ann = MKPointAnnotation()
            ann.setCoordinate(loc.location!)
            ann.title = loc.title
            mapView.addAnnotation(ann)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func onBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

//
//  NoteLocation.swift
//  MyNotes
//
//  Created by AJAY BAJWA on 2019-03-27.
//  Copyright © 2019 lambton. All rights reserved.
//

import Foundation
import MapKit

class NoteLocation: UIViewController {
    var latitude:Double = 0
    var longitude:Double = 0
    @IBOutlet weak var myMapView: MKMapView!
    //let noteLocation = CLLocation(latitude: 43.664520, longitude: -79.735816)
    @IBAction func btnGMaps(_ sender: UIButton) {
            
            if let url = URL(string: "https://www.google.com/maps/search/google+maps+\(latitude),\(longitude)?sa=X&ved=2ahUKEwjh7qPUnaPhAhWk0YMKHQFSCdIQ8gEwAHoECAEQAQ") {
                UIApplication.shared.open(url, options: [:])
            }
        
    }
    let regionRadius: CLLocationDistance = 300
    override func viewDidLoad() {
        print("user latitude = \(latitude)")
        print("user longitude = \(longitude)")
        let noteLocation = CLLocation(latitude: latitude, longitude: longitude)
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.title = "Note Location"
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(noteLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.myMapView.setRegion(coordinateRegion, animated: true)
        
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(noteLocation.coordinate.latitude, noteLocation.coordinate.longitude);
        myAnnotation.title = "Note Location"
        myAnnotation.subtitle = "\(latitude),\(longitude)"
        self.myMapView.addAnnotation(myAnnotation)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sgmMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            myMapView.mapType = MKMapType.standard
        case 1:
            myMapView.mapType = MKMapType.satellite
        case 2:
            myMapView.mapType = MKMapType.hybrid
            
        default:
            myMapView.mapType = MKMapType.standard
        }
    }
}

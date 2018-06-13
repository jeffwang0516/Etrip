//
//  MapViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/5.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let db = DBManager.instance
    
    var placeInfo: PlaceInfo?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        if let placeInfo = placeInfo {
            addressLabel.text = placeInfo.address
            
            let location = CLLocationCoordinate2D(latitude: placeInfo.lat, longitude: placeInfo.lng)
            mapView.setCenter(location, animated: true)
            let annotate = MKPointAnnotation()
            annotate.coordinate = location
            
            mapView.addAnnotation(annotate)
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let region = MKCoordinateRegionMakeWithDistance(
                location, 20000, 20000)
            
            
            mapView.setRegion(region, animated: true)
            
        }
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
//    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
//        
//    }
}

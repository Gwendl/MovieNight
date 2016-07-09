//
//  mapVC.swift
//  MovieNight
//
//  Created by Gwendal Lasson on 06/07/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit

class mapVC: UIViewController, MKMapViewDelegate{
    var mapView: MKMapView!
    var annotations: [MKAnnotation]!
    var region: MKCoordinateRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
       
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        mapView.addAnnotations(annotations)
        view.addSubview(mapView)
    }
}

//
//  detail.swift
//  MovieNight
//
//  Created by gwendal lasson on 13/06/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var movie = Movie()
    let regionRadius: CLLocationDistance = 1000
    
    let tvController = TheaterTableViewController()
    
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        synopsisTextView.text = movie.synopsis
        let initialLocation = CLLocation(latitude: 45.7573950, longitude: 4.8572230)
        centerMapOnLocation(initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvController.movie = movie
        tableView.delegate = tvController
        tableView.dataSource = tvController
        self.configureView()
    }
    
}

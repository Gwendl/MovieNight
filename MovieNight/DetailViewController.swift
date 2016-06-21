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
    
    var movie: Movie?
    var regionRadius: CLLocationDistance = 1000
    
    let tvController = TheaterTableViewController()
    
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        
        synopsisTextView.text = movie?.synopsis ?? "Aucun film sélectionné."
        
        if MovieListTableViewController.locValue != nil {
            
            synopsisTextView.text = movie!.synopsis
            let initialLocation = CLLocation(latitude: 45.7573950, longitude: 4.8572230)
            
            if let customRadius = (movie!.theaters.map{$0.distance}).maxElement() {
                regionRadius = Double(customRadius * 1000)
            }
            centerMapOnLocation(initialLocation)
            mapView.showsUserLocation = true
            
            for theater in movie!.theaters {
                let pin = Theater(title: theater.name, locationName: "", discipline: "Cinema",
                                  coordinate: CLLocationCoordinate2D(latitude: Double(theater.lat), longitude: Double(theater.long)))
                mapView.addAnnotation(pin)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadShowtimes() {
        
        if movie == nil {
            return
        }
        
        if movie!.theaters.count == 0 {
            return
        }
        
        if tvController.tableView == nil {
            return
        }
        
        tvController.movie = movie!
        tableView.reloadData()
        configureView()
    }
    
    func setMovie(film: Movie) {
        
        self.movie = film
        film.onShowtimesLoad = loadShowtimes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = tvController
        tableView.dataSource = tvController
        loadShowtimes()
        mapView.delegate = self
        self.configureView()
    }
    
}

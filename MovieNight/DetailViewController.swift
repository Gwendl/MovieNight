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
    var initialLocation: CLLocation? = nil
    
    let tvController = TheaterTableViewController()
    
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        
        movie?.usethumbNail(setThumbNail)
        synopsisTextView.text = movie?.synopsis ?? "Aucun film sélectionné."
        
        
        if MovieListTableViewController.locValue != nil {
            
            synopsisTextView.text = movie!.synopsis
            mapView.showsUserLocation = true
            
            if let customRadius = (movie!.theaters.map{$0.distance}).maxElement() {
                regionRadius = Double(customRadius * 1000)
            }
            if let unwrapedInitialLocation = initialLocation {
                centerMapOnLocation(unwrapedInitialLocation)
            }
            
            for theater in movie!.theaters {
                let pin = Theater(title: theater.name, locationName: "", discipline: "Cinema",
                                  coordinate: CLLocationCoordinate2D(latitude: Double(theater.lat), longitude: Double(theater.long)))
                mapView.addAnnotation(pin)
            }
        }
    }
    
    func setThumbNail(image: UIImage, _: Bool) {
        movieImage.image = image
        movieImage.setNeedsDisplay()
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
    
    func imageTapped() {
        let stringURL = "https://www.youtube.com/results?search_query=bande+annonce+" + ((self.movie?.name)!).stringByReplacingOccurrencesOfString(" ", withString: "+")
        if let URL = NSURL(string: stringURL) {
            UIApplication.sharedApplication().openURL(URL)
        }
    }
    
    func mapTapped() {
        let bigMap = mapVC()
        bigMap.annotations = mapView.annotations
        bigMap.region = mapView.region
        navigationController?.pushViewController(bigMap, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = tvController
        tableView.dataSource = tvController
        loadShowtimes()
        mapView.delegate = self
        let tapGestureRecognizerImage = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        let tapGestureRecognizerMap = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        movieImage.addGestureRecognizer(tapGestureRecognizerImage)
        mapView.addGestureRecognizer(tapGestureRecognizerMap)
        
        self.configureView()
    }
    
}

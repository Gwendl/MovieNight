//
//  MovieListViewController.swift
//  MovieNight
//
//  Created by Adrien morel on 4/26/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MovieListDelegate: class {
    func movieSelected(movie: Movie)
}

class MovieListTableViewController : UITableViewController, CLLocationManagerDelegate {
    
    var detailViewController: DetailViewController? = nil
    let locationManager = CLLocationManager()
    static var locValue: CLLocationCoordinate2D?
    var movies: [Movie] = []
    weak var delegate: MovieListDelegate?
    let api = MovieNightAPI(partnerKey: "100043982026", secretKey: "29d185d98c984a359e6e6f26a0474269")
    var calledApi = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.splitViewController?.preferredDisplayMode = .AllVisible
        
        getLocation()
    }
    
    func getLocation() {
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        MovieListTableViewController.locValue = manager.location?.coordinate
        if !calledApi {
            api.getMovies(populateTableView)
            calledApi = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    
    func sortMovies() {
        movies = movies.sort({(this, that) in
            return this.rate > that.rate
        })
    }
    
    func populateTableView(data: NSDictionary) {
        movies = api.movieList(data["movie"] as! NSArray)
        sortMovies()
        tableView.reloadData()
    }
    

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let name = "movieCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        
        func showsDidload(data: NSDictionary?) {
            
            if let data = data {
                movies[indexPath.row].dataToTheater(data)
                if cell.movieTheaterCount.text != String(movie.theaters.count) {
                    cell.movieTheaterCount.text = "\(movie.theaters.count) salles"
                    cell.movieTheaterCount.setNeedsDisplay()
                }
            } else {
                // TODO: show a label that says it's impossible to get location
            }
        }
        
        if !movie.theatersIsSet {
            movie.fillTheater(api, callBack: showsDidload)
        }
        
        cell.movieName.text = movie.name
        
        // set theaterCount
        cell.movieTheaterCount.text = "\(movie.theaters.count) salles"
        
        func setImage(image: UIImage, loaded: Bool) {
            
            if (loaded) {
                UIView.transitionWithView(cell.moviePoster,
                                          duration: 1,
                                          options: UIViewAnimationOptions.TransitionCrossDissolve,
                                          animations: { cell.moviePoster.image = image },
                                          completion: nil)
            } else {
                cell.moviePoster.image = image
            }
        }
        
        cell.moviePoster.image = nil
        movie.usePoster(setImage)
        
        cell.setRating(movie.rate)
        
        return cell
    }
    
    /*
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
     
     if let detailViewControler = self.delegate as? DetailViewController {
     splitViewController?.showDetailViewController(detailViewControler.navigationController!, sender: nil)
     }
     }
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if self.tableView.indexPathForSelectedRow != nil {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.movie = movies[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
    
}
//
//  MovieListViewController.swift
//  MovieNight
//
//  Created by Adrien morel on 4/26/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListDelegate: class {
    func movieSelected(movie: Movie)
}

class MovieListTableViewController : UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var movies: [Movie] = []
    weak var delegate: MovieListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = MovieNightAPI(partnerKey: "100043982026", secretKey: "29d185d98c984a359e6e6f26a0474269")
        
        api.getMovies(populateTableView)
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.splitViewController?.preferredDisplayMode = .AllVisible
        
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
    
    func populateTableView(data: [Movie]) {
        movies = data
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
        cell.movieName.text = movie.name
        
        // set theaterCount
        cell.movieTheaterCount.text = "\(movie.salle) salles"
        
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
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
}
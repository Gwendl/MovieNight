//
//  MovieListViewController.swift
//  MovieNight
//
//  Created by Adrien morel on 4/26/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import Foundation
import UIKit

class MovieListTableViewController : UITableViewController {
    
    var movies: NSArray = []
    var posters: [UIImage?]?
    
    override func viewDidLoad() {
        let api = MovieNightAPI(partnerKey: "100043982026", secretKey: "29d185d98c984a359e6e6f26a0474269")
        api.getMovies(populateTableView)
    }
    
    func sortMovies() {
        movies = movies.sort({(this, that) in
            let this = this as! NSDictionary
            let that = that as! NSDictionary
            
            let statsA = this["statistics"]
            let statsB = that["statistics"]
            
            if (statsA == nil) {
                return true
            } else if (statsB == nil) {
                return false
            }
            
            let gradeA = statsA!["userRating"] as? Float
            let gradeB = statsB!["userRating"] as? Float
            
            if (gradeA == nil) {
                return false
            } else if (gradeB == nil) {
                return true
            }
            
            return gradeA > gradeB
        
        })
    }
    
    func populateTableView(data: NSArray) {
        
        movies = data
        posters = [UIImage?](count: movies.count, repeatedValue: nil)
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
        
        let movieData = movies[indexPath.row]
        let statistics = movieData["statistics"] as! NSDictionary
        
        // set title
        let title = movieData["title"] as! String
        cell.movieName.text = title
        
        // set theaterCount
        let theaterCount = statistics["theaterCount"]!
        cell.movieTheaterCount.text = "\(theaterCount) salles"
        
        // set poster
        if let poster = movieData["poster"] as? NSDictionary {
        
            let posterLink = poster["href"] as! String
            
            cell.moviePoster.image = nil
            
            let imageView = cell.moviePoster
            
            func setImage() {
                
                UIView.transitionWithView(imageView,
                                          duration:1,
                                          options: UIViewAnimationOptions.TransitionCrossDissolve,
                                          animations: { imageView.image = self.posters![indexPath.row] },
                                          completion: nil)
            }
            
            if let poster = posters![indexPath.row] {
                
                cell.moviePoster.image = poster
                
            } else {
                
                if let url = NSURL(string: posterLink) {
                    let request = NSURLRequest(URL: url)
                    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                    let session = NSURLSession(configuration: config)
                    
                    let task = session.dataTaskWithRequest(request, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                        
                        if let imageData = data as NSData? {
                            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                                self.posters![indexPath.row] = UIImage(data: imageData)
                                setImage()
                            })
                        }
                    })
                    
                    task.resume()
                }
                
            }
        }
        
        // set rating
        if let rating = statistics["userRating"] as? Float {
            cell.setRating(rating)
            cell.ratingView.hidden = false
        } else {
            cell.ratingView.hidden = true
        }
        
        return cell
    }
}
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
    
    func populateTableView(data: NSArray) {
        
        movies = data
        print(movies)
        posters = [UIImage?](count: movies.count, repeatedValue: nil)
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
        
        let title = movieData["title"] as! String
        cell.movieName.text = title
        
        let poster = movieData["poster"] as! NSDictionary
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
        
        return cell
    }
    
    
    
}
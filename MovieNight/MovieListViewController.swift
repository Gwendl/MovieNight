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
    
    override func viewDidLoad() {
        let api = MovieNightAPI(partnerKey: "100043982026", secretKey: "29d185d98c984a359e6e6f26a0474269")
        api.getMovies(test)
    }
    
    func test(data: NSArray) {
        movies = data
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
        let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath)
        
        return cell
    }
}
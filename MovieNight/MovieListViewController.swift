//
//  MovieListViewController.swift
//  MovieNight
//
//  Created by Adrien morel on 4/26/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//http://api.allocine.fr/rest/v3/showtimelist?partner=100043982026&radius=50&lat=49.0176394&long=-0.3498&format=json&sed=20160428&sig=550u1OOn%2FJ6JkVwqf%2BuxwHQw%2Bz0%3D

import Foundation
import UIKit

class MovieListTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        let api = MovieNightAPI(partnerKey: "pkey", secretKey: "skey")
        api.request("showtimelist", params: ["partner": "100043982026", "radius": "50", "lat": "49.0176394",
            "long": "-0.3498", "format": "json"])
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) 
        
        return cell
    }
}
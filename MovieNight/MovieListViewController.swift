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
    
    override func viewDidLoad() {
        let api = MovieNightAPI(partnerKey: "pkey", secretKey: "skey")
        api.getMovies(test)
    }
    
    func test(data: NSArray) {
        for x in data {
            print(x)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    var i = 0
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var name = "movieCell\(i++)"
        let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath)
        
        return cell
    }
}
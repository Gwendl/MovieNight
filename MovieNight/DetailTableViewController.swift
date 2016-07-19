//
//  DetailTableViewController.swift
//  MovieNight
//
//  Created by gwendal lasson on 17/07/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {
   
    var movie: Movie?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    
    var initialLocation: CLLocation? = nil
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movie?.theaters.count)! + 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 750
        }
        return 150
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let name = "infoCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath) as! InfoCell
            cell.tableViewReference = self
            cell.configureCell()
            return cell
        }
        
        let name = "showtimeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath) as! ShowtimeCell
        
        if !cell.contentView.subviews.isEmpty {
            for subView in cell.contentView.subviews {
                let conditionalView = subView as? ASHorizontalscrollViewWithIndex
                conditionalView?.removeFromSuperview()
            }
        }
        
        cell.tableViewReference = self
        cell.configureCell(indexPath)
        return cell
    }
    
    func setMovie(film: Movie) {
        
        self.movie = film
        film.onShowtimesLoad = loadShowtimes
    }
    
    func launchBigMap(mapView: MKMapView) {
        let bigMap = mapVC()
        bigMap.annotations = mapView.annotations
        bigMap.region = mapView.region
        navigationController?.pushViewController(bigMap, animated: true)
    }
    
    func loadShowtimes() {
        
        if movie == nil {
            return
        }
        
        if movie!.theaters.count == 0 {
            return
        }
        
        tableView.reloadData()
    }
    
    func configureView() {
    }
    
    override func viewDidLoad() {
        configureView()
    }
}

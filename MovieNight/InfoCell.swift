//
//  InfoCell.swift
//  MovieNight
//
//  Created by gwendal lasson on 17/07/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit

class InfoCell: UITableViewCell, MKMapViewDelegate {
    
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSynopsis: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    var tableViewReference: DetailTableViewController?
    var regionRadius = 10000.0
    
    override func awakeFromNib() {
        mapView.delegate = self
        tableViewReference?.movie?.usethumbNail(setThumbNail)
    }
    
    func launchTrailer() {
        let stringURL = "https://www.youtube.com/results?search_query=bande+annonce+" + ((tableViewReference!.movie?.name)!).stringByReplacingOccurrencesOfString(" ", withString: "+")
        if let URL = NSURL(string: stringURL) {
            UIApplication.sharedApplication().openURL(URL)
        }
    }
    
    func launchBigMap() {
        tableViewReference?.launchBigMap(mapView)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 1.0, regionRadius * 1.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func setThumbNail(image: UIImage, _: Bool) {
        thumbnail.image = image
        thumbnail.setNeedsDisplay()
    }
    
    func cleanHTML(string: String) -> String {
        var cleanedString = string
        
        if let regex = try? NSRegularExpression(pattern: "<[^>]*>", options: .CaseInsensitive) {
            cleanedString = regex.stringByReplacingMatchesInString(string, options: .WithTransparentBounds, range: NSMakeRange(0, string.characters.count), withTemplate: "")
        }
        return cleanedString
    }
    
    func configureCell() {
        
        tableViewReference?.movie?.usethumbNail(setThumbNail)
        movieSynopsis.text = cleanHTML((tableViewReference?.movie?.synopsis)!)
        movieTitle.text = tableViewReference?.movie?.name
        
        if let customRadius = (tableViewReference?.movie!.theaters.map{$0.distance})!.maxElement() {
            regionRadius = Double(customRadius * 2000)
        }
        
        if let location = tableViewReference?.initialLocation {
            centerMapOnLocation(location)
        }
        
        for theater in tableViewReference!.movie!.theaters {
            let pin = Theater(title: theater.name, locationName: "", discipline: "Cinema",
                              coordinate: CLLocationCoordinate2D(latitude: Double(theater.lat), longitude: Double(theater.long)))
            mapView.addAnnotation(pin)
        }
        
        let tapThumbnail = UITapGestureRecognizer(target: self, action: #selector(InfoCell.launchTrailer))
        let tapMap = UITapGestureRecognizer(target: self, action: #selector(launchBigMap))
        thumbnail.addGestureRecognizer(tapThumbnail)
        mapView.addGestureRecognizer(tapMap)
    }
}

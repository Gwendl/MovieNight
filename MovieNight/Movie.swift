//
//  Movie.swift
//  MovieNight
//
//  Created by gwendal lasson on 13/06/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit

class Movie {
    
    class Theater {
        let name: String
        let lat: Float
        let long: Float
        let postalCode: Int
        let distance: Float
        var showTimes: [String] = []
        
        init (name: String, postalCode: Int, lat: Float, long: Float, distance: Float) {
            self.name = name
            self.postalCode = postalCode
            self.lat = lat
            self.long = long
            self.distance = distance
        }
    }
    
    let posterURL: NSURL
    let thumbNailURL: NSURL
    
    private var poster: UIImage?
    private var thumbNail: UIImage?
    
    let name: String
    let code: Int
    let rate: Float
    let synopsis: String
    var theaters: [Theater] = []
    var theatersIsSet = false
    
    var onShowtimesLoad: (() -> ())?
    
    init(name: String, code: Int, rate: Float, synopsis: String, posterURL: NSURL, thumbNailURL: NSURL)
    {
        self.name = name
        self.rate = rate
        self.posterURL = posterURL
        self.thumbNailURL = thumbNailURL
        self.code = code
        self.synopsis = synopsis
    }
    
    init () {
        name = ""
        rate = 0
        posterURL = NSURL(string: "")!
        thumbNailURL = NSURL(string: "")!
        code = 0
        synopsis = ""
    }
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    private func imageThroughCallBack(isPoster: Bool, callBack: (UIImage, Bool)->()) {
        
        let testimage: UIImage?
        
        if isPoster {
            testimage = poster
        } else {
            testimage = thumbNail
        }
        
        if let img = testimage {
            callBack(img, false)
        } else {
            getDataFromUrl(isPoster ? posterURL : thumbNailURL) { (data, response, error)  in
                if let data = data {
                    let image = UIImage(data: data)
                    
                    if isPoster {
                        self.poster = image
                    } else {
                        self.thumbNail = image
                    }
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        callBack(image!, true)
                    }
                }
            }
        }
    }
    
    func usePoster(callBack: (UIImage, Bool)->()) {
        imageThroughCallBack(true, callBack: callBack)
    }
    
    func usethumbNail(callBack: (UIImage, Bool)->()) {
        imageThroughCallBack(false, callBack: callBack)
    }
    
    func dataToTheater(data: NSDictionary) {
        if let theaterList = data["theaterShowtimes"] as! NSArray? {
            
            for item in theaterList {
                let todayShows = ((((item["movieShowtimes"] as! NSArray)[0] as! NSDictionary)["scr"] as! NSArray)[0] as! NSDictionary)
                
                let date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                let today = String(components.year) + "-" + String(format: "%02d", components.month)
                    + "-" + String(format: "%02d", components.day)
                
                var showTimes = [String]()
                if today == todayShows["d"] as! String {
                    for show in todayShows["t"] as! NSArray {
                        showTimes.append((show as! NSDictionary)["$"] as! String)
                    }
                }
                
                let place = (item as! NSDictionary)["place"] as! NSDictionary?
                let theater = place?["theater"] as! NSDictionary?
                let distance = theater!["distance"] as! Float?
                let name = theater?["name"] as! String?
                let postalCode = (theater?["postalCode"] as! String?)
                let lat = (theater?["geoloc"] as! NSDictionary?)?["lat"] as! Float?
                let long = (theater?["geoloc"] as! NSDictionary?)?["long"] as! Float?
                
                if (name != nil && postalCode != nil && lat != nil && long != nil && distance != nil) {
                    theaters.append(Theater(name: name!, postalCode: Int(postalCode!)!, lat: lat!, long: long!, distance: distance!))
                    theaters.last?.showTimes = showTimes
                }
            }
            self.onShowtimesLoad?()
        }
    }
    
    func fillTheater(api: MovieNightAPI, callBack: (NSDictionary?) -> Void) {
        api.getShows(code, callBack: callBack)
        theatersIsSet = true
    }
}

//
//  MovieNightAPI.swift
//  MovieNight
//
//  Created by Gwendal Lasson on 27/04/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import CoreLocation


extension String {
    
    func toBase64()->String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
}

class MovieNightAPI {
    let APIURL = "http://api.allocine.fr/rest/v3"
    var partnerKey: String
    var secretKey: String
    
    init (let partnerKey: String, let secretKey: String) {
        
        self.partnerKey = partnerKey
        self.secretKey = secretKey
    }
    
    func request(let method: String, let params: [String: String], callBack: NSDictionary -> Void) {
        
        let queryURL = APIURL + "/" + method + "?"
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let today = String(components.year) + String(format: "%02d", components.month)
            + String(format: "%02d", components.day)
        
        var query = ""
        var isFirstValue = true
        for (key, value) in params {
            if !isFirstValue {
                query += "&"
            }
            query += key + "=" + value
            isFirstValue = false
        }
        query += "&sed=" + today
        let data = (self.secretKey + query).dataUsingEncoding(NSUTF8StringEncoding)!
        let hash = data.sha1()!
        let base64Decoded = hash.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let finalString = NSString(data: base64Decoded, encoding: NSUTF8StringEncoding)
        query += "&sig=" + (finalString as! String)
        
        print(queryURL + query)
        
        Alamofire.request(.POST, queryURL + query,  encoding:.JSON).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                let data = JSON as! NSDictionary
              //  print(data)
                let feed = data.valueForKey("feed") as! NSDictionary
                callBack(feed)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
    }
    
    func getMovies(callBack: (NSDictionary) -> Void) {
        self.request("movielist", params: ["count": "30", "partner": partnerKey, "filter": "nowshowing"], callBack: callBack)
    }
    
    func getShows(code: Int, callBack: (NSDictionary?) -> Void) {
        
        if let locValue = MovieListTableViewController.locValue {
        
            self.request("showtimelist", params: ["partner": partnerKey, "count": "20",
                "lat": "\(locValue.latitude)", "long": "\(locValue.longitude)", "profile": "medium",
                "radius": "10", "movie": "\(code)"], callBack: callBack)
        } else {
            
            /* TODO: complete this never
 
            if CLLocationManager.locationServicesEnabled() {
                
                if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
                    let alert = UIAlertController(title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: .Alert)
                    self.
                }
            }
            */
            callBack(nil)
        }
    }
    
    func movieList(infos: NSArray) -> [Movie] {
        var movieList = [Movie]()
        
        for movie in infos {
            let m = movie as! NSDictionary
            let title = m.valueForKey("title") as! String?
            let code = m.valueForKey("code") as! Int?
            
            
            let statistics = m.valueForKey("statistics") as! NSDictionary?
            let userRating = statistics?.valueForKey("userRating") as! Float?
            let salles = statistics?["theaterCount"] as! Int?
            
            
            let poster = m.valueForKey("poster") as! NSDictionary?
            let posterURLString = poster?.valueForKey("href") as! String?
            var posterURL: NSURL? = nil
            if posterURLString != nil {
                posterURL = NSURL(string: posterURLString!)
            }
            
            let defaultMedia = m.valueForKey("defaultMedia") as! NSDictionary?
            let media = defaultMedia?.valueForKey("media") as! NSDictionary?
            let thumbNail = media?.valueForKey("thumbnail") as! NSDictionary?
            let thumbNailURLString = thumbNail?.valueForKey("href") as! String?
            var thumbNailURL: NSURL? = nil
            if thumbNailURLString != nil {
                thumbNailURL = NSURL(string: thumbNailURLString!)
            }
            
            if (thumbNailURL != nil && posterURL != nil && title != nil &&
                code != nil && userRating != nil && salles != nil) {
                
                movieList.append(Movie(name: title!, code: code!, rate: userRating!, posterURL: posterURL!, thumbNailURL: thumbNailURL!))
            }
        }
        return movieList
    }
    
}
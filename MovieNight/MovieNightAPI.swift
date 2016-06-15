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
    
    func request(let method: String, let params: [String: String], callBack: [Movie] -> Void, key: String) {
        
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
        
        
        Alamofire.request(.POST, queryURL + query,  encoding:.JSON).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                let data = JSON as! NSDictionary
                let feed = data.valueForKey("feed") as! NSDictionary
                let movieList = self.movieList(feed.valueForKey(key) as! NSArray)
                callBack(movieList)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
    }
    
    func getMovies(callBack: ([Movie]) -> Void) {
        self.request("movielist", params: ["count": "50", "partner": self.partnerKey, "filter": "nowshowing", "format": "json"], callBack: callBack, key: "movie")
    }
    
    func movieList(infos: NSArray) -> [Movie] {
        var movieList = [Movie]()
        
        for movie in infos {
            let m = movie as! NSDictionary
            let title = m.valueForKey("title") as! String?
            
            
            let statistics = m.valueForKey("statistics") as! NSDictionary?
            let userRating = statistics?.valueForKey("userRating") as! Float?
            
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
            print(thumbNailURL)
            print(posterURL)
            print(title)
            print(userRating)
            
            if (thumbNailURL != nil && posterURL != nil && title != nil && userRating != nil) {
                movieList.append(Movie(name: title!, rate: userRating!, posterURL: posterURL!, thumbNailURL: thumbNailURL!))
            }
        }
        return movieList
    }
    
}
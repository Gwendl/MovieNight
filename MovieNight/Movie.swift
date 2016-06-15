//
//  Movie.swift
//  MovieNight
//
//  Created by gwendal lasson on 13/06/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit

class Movie {
    
    let posterURL: NSURL
    let thumbNailURL: NSURL
    
    private var poster: UIImage?
    private var thumbNail: UIImage?
    
    let name: String
    let rate: Float
    let salle: Int
    
    init(name: String, rate: Float, salle: Int, posterURL: NSURL, thumbNailURL: NSURL)
    {
        self.name = name
        self.rate = rate
        self.salle = salle
        self.posterURL = posterURL
        self.thumbNailURL = thumbNailURL
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
            getDataFromUrl(posterURL) { (data, response, error)  in
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
}

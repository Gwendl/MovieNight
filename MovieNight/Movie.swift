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
    
    init(name: String, rate: Float, posterURL: NSURL, thumbNailURL: NSURL)
    {
        self.name = name
        self.rate = rate
        self.posterURL = posterURL
        self.thumbNailURL = thumbNailURL
    }
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    private func imageThroughCallBack(inout image: UIImage?, callBack: (UIImage)->()) {
        if image == nil {
            getDataFromUrl(posterURL) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    image = UIImage(data: data)
                    callBack(image!)
                }
            }
        } else {
            callBack(image!)
        }
    }
    
    func usePoster(callBack: (UIImage)->()) {
        imageThroughCallBack(&poster, callBack: callBack)
    }
    
    func usethumbNail(callBack: (UIImage)->()) {
        imageThroughCallBack(&poster, callBack: callBack)
    }
}

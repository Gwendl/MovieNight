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
    let userAgent = "Dalvik/1.6.0 (Linux; U; Android 4.2.2; Nexus 4 Build/JDQ39E)"
    var partnerKey: String
    var secretKey: String
    
    init (let partnerKey: String, let secretKey: String) {
        
        self.partnerKey = partnerKey
        self.secretKey = secretKey
    }
    
    func request(let method: String, let params: [String: String]) -> Bool {
        
        var queryURL = APIURL + "/" + method + "?"
        
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
        query += "&sig=" + "M5tAaiKA%2FwSYn2ERzDVeai2uZcA%3D"
        
        Alamofire.request(.GET, queryURL + query)
            .responseJSON { response in
                debugPrint(response)
        }
        return true
    }
}
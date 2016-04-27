//
//  MovieMDBModel.swift
//  MDBSwiftWrapper
//
//  Created by George on 2016-03-08.
//  Copyright © 2016 GeorgeKye. All rights reserved.
//

import Foundation


//Sublass and inherit all related methods and variables here**
public class MovieMDB:  DiscoverMovieMDB {
    
    public var title: String!
    public var video: Bool!
    public var release_date: String!
    public var original_title: String!
    
    override init(results: JSON) {
        super.init(results: results)
        
        if(results["title"] != nil){
            title = results["title"].string
        }else{
            title = nil
        }
        
        if(results["video"] != nil){
            video = results["video"].bool
        }else{
            video = nil
        }
        
        if(results["adult"] != nil){
            adult = results["adult"].bool
        }else{
            adult = nil
        }
        
        if(results["release_date"] != nil){
            release_date = results["release_date"].string
        }else{
            release_date = nil
        }
        
        if(results["original_title"] != nil){
            original_title = results["original_title"].string
        }else{
            original_title = nil
        }
    }
    
    //Init function to return array of MovieMDB objs
    class func initialize(json: JSON)->[MovieMDB] {
        var movieArray = [MovieMDB]()
        for i in 0 ..< json.count {
            movieArray.append(MovieMDB(results: json[i]))
        }
        return movieArray
    }
}

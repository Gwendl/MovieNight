//
//  ViewController.swift
//  MovieNight
//
//  Created by Gwendal Lasson on 26/04/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit


class MainSplitView: UISplitViewController {

    static let appColor = UIColor(red: 0xFF / 255, green: 0x2D / 255, blue: 0x55 / 255, alpha: 0x00 / 255)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = NSURL(string: "http://www.stackoverflow.com")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()

        
        
        // Do any additional setup after loading the view, typically from a nib.

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


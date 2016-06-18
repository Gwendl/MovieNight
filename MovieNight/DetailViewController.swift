//
//  detail.swift
//  MovieNight
//
//  Created by gwendal lasson on 13/06/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        // configure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
}

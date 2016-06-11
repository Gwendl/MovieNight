//
//  ViewController.swift
//  MovieNight
//
//  Created by Gwendal Lasson on 26/04/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit


class MainSplitView: UISplitViewController, UISplitViewControllerDelegate {

    static let appColor = UIColor(red: 0xFF / 255, green: 0x2D / 255, blue: 0x55 / 255, alpha: 0x00 / 255)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//
//  theater.swift
//  MovieNight
//
//  Created by gwendal lasson on 19/06/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit
import ASHorizontalScrollView

class ASHorizontalscrollViewWithIndex: ASHorizontalScrollView {
    
    var indexPath: NSIndexPath
    
    init (frame: CGRect, indexPath: NSIndexPath) {
        self.indexPath = indexPath
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TheaterTableViewController: UITableViewController {
    
    var movie = Movie()
    var mapViewReference: MKMapView?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.theaters.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("theaterCell", forIndexPath: indexPath)
            as! TheaterTableViewCell
        
        if !cell.contentView.subviews.isEmpty {
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
            }}
        
        func padNumber(num: Float) -> String {
            return String(format: "%.2fkm", num)
        }
        
        let theater = movie.theaters[indexPath.row]
        cell.theaterName.text = "\(theater.name)"
        cell.theaterDistance.text = padNumber(theater.distance)
        let showTimeView = ASHorizontalscrollViewWithIndex(frame:CGRectMake(0, 30, tableView.frame.size.width, 50), indexPath: indexPath)
        showTimeView.miniAppearPxOfLastItem = 10
        showTimeView.uniformItemSize = CGSizeMake(120, 50)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TheaterTableViewController.showTimeViewTapped(_:)))
        showTimeView.addGestureRecognizer(tapGestureRecognizer)
        
        print(cell.contentView.frame.height)
        if theater.showTimes.count > 0 {
            for i in 0...theater.showTimes.count - 1 {
                let timeLabel = UIButton(frame: CGRectZero)
                timeLabel.backgroundColor = UIColor.clearColor()
                timeLabel.layer.cornerRadius = 5
                timeLabel.layer.borderWidth = 1
                timeLabel.layer.borderColor = UIColor.blackColor().CGColor
                timeLabel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                timeLabel.setTitle("\(theater.showTimes[i]) (vf)", forState: UIControlState.Normal)
                timeLabel.userInteractionEnabled = false
                showTimeView.addItem(timeLabel)
            }
        } else {
            showTimeView.uniformItemSize = CGSizeMake(220, 50)
            let noShowLabel = UILabel(frame: CGRectZero)
            noShowLabel.text = "Plus de scéance aujourd'hui"
            showTimeView.addItem(noShowLabel)
        }
        
        cell.contentView.addSubview(showTimeView)
        return cell
    }
    
    func showTimeViewTapped(sender: UITapGestureRecognizer) {
        tableView.delegate?.tableView!(tableView, didSelectRowAtIndexPath: (sender.view as! ASHorizontalscrollViewWithIndex).indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let coordinate = mapViewReference?.annotations[indexPath.row].coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate!, addressDictionary:nil))
        mapItem.name = movie.theaters[indexPath.row].name
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
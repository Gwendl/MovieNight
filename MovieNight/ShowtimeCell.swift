//
//  ShowtimeCell.swift
//  MovieNight
//
//  Created by gwendal lasson on 17/07/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit
import MapKit

class ShowtimeCell: UITableViewCell {
    
    @IBOutlet weak var theaterNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var distance: Float?
    var theaterName: String?
    var tableViewReference: DetailTableViewController?
    var cellIndex: NSIndexPath?
    
    
    override func awakeFromNib() {
    }
    
    func configureCell(indexPath: NSIndexPath)  {
        
        self.cellIndex = indexPath
        
        let movie = tableViewReference?.movie
                theaterNameLabel.text = movie!.theaters[indexPath.row - 1].name
        let distanceToTheater = movie!.theaters[indexPath.row - 1].distance
        distanceLabel.text = String(format: "%.2f km", distanceToTheater)
        
        let showTimeView = ASHorizontalscrollViewWithIndex(frame:CGRectMake(0, 62, contentView.frame.size.width, 60), indexPath: indexPath)
        showTimeView.miniAppearPxOfLastItem = 50
        showTimeView.uniformItemSize = CGSizeMake(100, 40)
        showTimeView.leftMarginPx = 24
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        showTimeView.addGestureRecognizer(tapGestureRecognizer)
        
        let theater = tableViewReference!.movie?.theaters[indexPath.row - 1]
        if theater!.showTimes.count > 0 {
            for i in 0...theater!.showTimes.count - 1 {
                let timeButton = UIButton(frame: CGRectZero)
                timeButton.backgroundColor = UIColor.clearColor()
                let pink = UIColor(red: 0xFF / 255, green: 0x40 / 255, blue: 0x5C / 255, alpha: 1)
                timeButton.layer.cornerRadius = 2
                timeButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
                timeButton.layer.borderWidth = 1
                timeButton.layer.borderColor = pink.CGColor
                timeButton.setTitleColor(pink, forState: UIControlState.Normal)
                timeButton.setTitle("\(theater!.showTimes[i])", forState: UIControlState.Normal)
                timeButton.userInteractionEnabled = false
                showTimeView.addItem(timeButton)
            }
        } else {
            showTimeView.uniformItemSize = CGSizeMake(220, 50)
            let noShowLabel = UILabel(frame: CGRectZero)
            noShowLabel.text = "Plus de scéance aujourd'hui"
            showTimeView.addItem(noShowLabel)
        }
        
        contentView.addSubview(showTimeView)
    }
    
    func showMap() {
        
        let theater = self.tableViewReference!.movie?.theaters[cellIndex!.row]
        let coordinate = CLLocationCoordinate2D(latitude: Double(theater!.lat), longitude: Double(theater!.long))
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = theater!.name
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

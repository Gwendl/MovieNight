//
//  ShowtimeCell.swift
//  MovieNight
//
//  Created by gwendal lasson on 17/07/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit

class ShowtimeCell: UITableViewCell {
    
    @IBOutlet weak var theaterNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var distance: Float?
    var theaterName: String?
    var tableViewReference: DetailTableViewController?
    
    
    override func awakeFromNib() {
    }
    
    func configureCell(indexPath: NSIndexPath)  {
        let movie = tableViewReference?.movie
                theaterNameLabel.text = movie!.theaters[indexPath.row - 1].name
        let distanceToTheater = movie!.theaters[indexPath.row - 1].distance
        distanceLabel.text = String(format: "%.2f km", distanceToTheater)
        
        let showTimeView = ASHorizontalscrollViewWithIndex(frame:CGRectMake(, 30, contentView.frame.size.width, 50), indexPath: indexPath)
        showTimeView.miniAppearPxOfLastItem = 10
        showTimeView.uniformItemSize = CGSizeMake(120, 20)
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TheaterTableViewController.showTimeViewTapped(_:)))
        //showTimeView.addGestureRecognizer(tapGestureRecognizer)
        
        let theater = tableViewReference!.movie?.theaters[indexPath.row - 1]
        if theater!.showTimes.count > 0 {
            for i in 0...theater!.showTimes.count - 1 {
                let timeLabel = UIButton(frame: CGRectZero)
                timeLabel.backgroundColor = UIColor.clearColor()
                timeLabel.layer.cornerRadius = 5
                timeLabel.layer.borderWidth = 1
                timeLabel.layer.borderColor = UIColor.blackColor().CGColor
                timeLabel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                timeLabel.setTitle("\(theater!.showTimes[i]) (vf)", forState: UIControlState.Normal)
                timeLabel.userInteractionEnabled = false
                showTimeView.addItem(timeLabel)
            }
        } else {
            showTimeView.uniformItemSize = CGSizeMake(220, 50)
            let noShowLabel = UILabel(frame: CGRectZero)
            noShowLabel.text = "Plus de scéance aujourd'hui"
            showTimeView.addItem(noShowLabel)
        }
        
        contentView.addSubview(showTimeView)
    }
}

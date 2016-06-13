//
//  MovieTableViewCell.swift
//  MovieNight
//
//  Created by Adrien Morel on 11/06/16.
//  Copyright © 2016 Gwendal Lasson. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieTheaterCount: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRating(grade: Float) {

        func setStar(imageView: UIImageView, id: Float) {
            if (grade <= id) {
                imageView.image = UIImage(named: "star0")
            }
            else if (grade - id > 0.75) {
                imageView.image = UIImage(named: "star1")
            } else {
                imageView.image = UIImage(named: "star05")
            }
        }
        
        setStar(star1, id: 0)
        setStar(star2, id: 1)
        setStar(star3, id: 2)
        setStar(star4, id: 3)
        setStar(star5, id: 4)
        
        print(grade)
    }

}

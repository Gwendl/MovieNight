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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

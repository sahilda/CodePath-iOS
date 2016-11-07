//
//  FirstMenuTableViewCell.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/7/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class FirstMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var user = User.currentUser
    
    func loadData() {
        nameLabel.text = user?.name
        descriptionLabel.text = user?.tagline
        profileImageView.setImageWith(user!.profileURL!)
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 7
        
    }
    
}

//
//  AccountsCell.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/7/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class AccountsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BusinessCell.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var business: Business! {
        didSet {
            thumbImageView.setImageWith(business.imageURL!)
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith(business.ratingImageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

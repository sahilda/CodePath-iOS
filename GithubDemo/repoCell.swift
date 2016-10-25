//
//  repoCell.swift
//  GithubDemo
//
//  Created by Sahil Agarwal on 10/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class repoCell: UITableViewCell {
    
    var repo: GithubRepo! {
        didSet {
            nameLabel.text = repo.name
            ownerLabel.text = repo.ownerHandle
            avatorImage.setImageWith(URL(string: repo.ownerAvatarURL!)!)
            starsImage.image = UIImage(named: "star")
            starsLabel.text = String(describing: repo.stars!)
            forksImage.image = UIImage(named: "fork")
            forksLabel.text = String(describing: repo.forks!)
            repoDescriptionLabel.text = repo.repoDescription
    }}
    var name: String! 
    var owner: String!
    var stars: Int!
    var forks: Int!
    var repoDescription: String!
    var avator: String!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksImage: UIImageView!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

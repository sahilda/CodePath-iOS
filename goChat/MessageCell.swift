//
//  MessageCell.swift
//  goChat
//
//  Created by Sahil Agarwal on 10/27/16.
//
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var chatLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

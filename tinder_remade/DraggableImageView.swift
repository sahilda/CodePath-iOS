//
//  DraggableImageView.swift
//  tinder_remade
//
//  Created by Sahil Agarwal on 11/10/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class DraggableImageView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var image: UIImage? {
        get { return profileImageView.image }
        set { profileImageView.image = newValue }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DraggableImageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(profileImageView)
    }

}

//
//  SwitchCell.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchcell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell, SwitchCellDelegate {

    @IBOutlet weak var switchLabel: UILabel!
    var switchButton: UIButton!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton = createSwitchButton()
        switchButton.addTarget(self, action: #selector(SwitchCell.buttonValueChanged), for: UIControlEvents.touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func buttonValueChanged() {
        switchButton.isSelected = !switchButton.isSelected
        delegate?.switchCell?(switchcell: self, didChangeValue: switchButton.isSelected)
    }
    
    func createSwitchButton() -> UIButton {
        let switchButton = UIButton()
        self.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        let cellMargins = self.layoutMarginsGuide
        let labelMargins = switchLabel.layoutMarginsGuide
        switchButton.rightAnchor.constraint(equalTo: cellMargins.rightAnchor, constant: 0).isActive = true
        switchButton.leftAnchor.constraint(greaterThanOrEqualTo: labelMargins.rightAnchor, constant: 40).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        switchButton.setImage(UIImage(named: "onSwitch"), for: .selected)
        switchButton.setImage(UIImage(named: "offSwitch"), for: .normal)
        return switchButton
    }
}

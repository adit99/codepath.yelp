//
//  SwitchViewCell.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SwitchViewCellDelegate  {
    
    func didChangeFilter(sender: SwitchViewCell, value: Bool)
}

class SwitchViewCell: UITableViewCell {
    
    
    var onSwitch: UISwitch?
    var delegate : SwitchViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch = UISwitch()
        
        self.onSwitch?.addTarget(self, action: "onSwitchChange", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onSwitchChange() {
        //var dict = ["switch" : self.onSwitch.enabled]
        self.delegate?.didChangeFilter(self, value: self.onSwitch!.on)
    }
}

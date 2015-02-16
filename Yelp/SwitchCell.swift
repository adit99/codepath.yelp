//
//  SwitchCell.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/14/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate  {
    
    func didChangeFilter(sender: SwitchCell, key: String, value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    var delegate : SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.onSwitch?.addTarget(self, action: "onSwitchChange", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onSwitchChange() {
        self.delegate?.didChangeFilter(self, key: self.Label!.text!, value: self.onSwitch!.on)
    }
}

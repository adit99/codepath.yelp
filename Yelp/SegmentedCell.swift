//
//  SegmentedCell.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/14/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SegmentedCellDelegate  {
    
    func didChangeFilter(sender: SegmentedCell, key: String, value: Int)
}

class SegmentedCell: UITableViewCell {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    var delegate : SegmentedCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.SegmentControl?.addTarget(self, action: "onSegmentChange", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func onSegmentChange() {
        self.delegate?.didChangeFilter(self, key: self.Label!.text!, value: self.SegmentControl!.selectedSegmentIndex)
    }
    
  
    
}

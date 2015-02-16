//
//  BusinessCell.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/10/15.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var cetegoriesLabel: UILabel!
    @IBOutlet weak var numReviewsLabel: UILabel!
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }
    
    func initCellFromBusinessDictionary(dictionary: NSDictionary) {
        
        //println("initcellfromBusinessDict \(dictionary)")
        
        if var distance = dictionary["distance"] as? Double {
            distance = distance * 0.0006
             self.distanceLabel.text = String(format: "%.1f", distance) + " mi"
        } else {
            self.distanceLabel.hidden = true
        }
        
        self.nameLabel.text = dictionary["name"] as NSString
        /*self.nameLabel.numberOfLines = 0
        self.nameLabel.sizeToFit()  
        self.nameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.nameLabel.setNeedsDisplay()
        self.nameLabel.updateConstraints()*/
        //println(self.nameLabel.text)
        //println(self.nameLabel.frame.size.height)
        
        self.numReviewsLabel.text = String(dictionary["review_count"] as Int)
        
        if let  cats = dictionary["categories"] as? NSArray {
            var categories = ""
            for i in 0...(cats.count - 1) {
                let cat = cats[i] as NSArray
                categories += cat[0] as NSString
                categories += ", "
            }
            self.cetegoriesLabel.text = dropLast(dropLast(categories))
        } else {
            self.cetegoriesLabel.text = ""
        }
        
        let loc = (dictionary["location"] as NSDictionary)
        if (loc["address"] as NSArray).count != 0 {
            self.addressLabel.text = (loc["address"] as NSArray)[0] as NSString
        } else {
            self.addressLabel.text = (loc["display_address"] as NSArray)[0] as NSString
        }
        
        self.setThumbImageViewFromURL(dictionary["image_url"] as? NSString)
        self.setRatingsImageViewFromURL(dictionary["rating_img_url_small"] as? NSString)
    }
    
    func setThumbImageViewFromURL(imageURL: NSString?) {
        
        if imageURL != nil {
            let url = NSURL(string: imageURL!)
            let url_request = NSURLRequest(URL: url!)
            let placeholder = UIImage(named: "no_photo")
            self.thumbImageView.setImageWithURL(url)
        }
    }
    
    func setRatingsImageViewFromURL(imageURL: NSString?) {
        let url = NSURL(string: imageURL!)
        let url_request = NSURLRequest(URL: url!)
        let placeholder = UIImage(named: "no_photo")        
        self.starsImage.setImageWithURL(url)
    }

    
    override  func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }
}

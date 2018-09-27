//
//  CatalogProductReviewTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 16/09/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CatalogProductReviewTableViewCell: UITableViewCell {
    
    
@IBOutlet weak var ReviewsHeading: UILabel!
@IBOutlet weak var ReviewsDate: UILabel!
@IBOutlet weak var reviewBy: UILabel!
@IBOutlet weak var reviewsDetails: UILabel!
@IBOutlet weak var dynamicView: UIView!
@IBOutlet weak var dynamicViewHeightConstarints: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  SellerReviewsCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 08/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerReviewsCell: UITableViewCell {
@IBOutlet weak var mainView: UIView!
@IBOutlet weak var review1View: UIView!
@IBOutlet weak var valueLabel: UILabel!
@IBOutlet weak var valueRating: UILabel!
@IBOutlet weak var review2View: UIView!
@IBOutlet weak var priceRating: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var review3View: UIView!
@IBOutlet weak var qualityRating: UILabel!
@IBOutlet weak var qualityLabel: UILabel!
@IBOutlet weak var heading: UILabel!
@IBOutlet weak var message: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       review1View.applyGradientToTopView(colours: STARGRADIENT, locations: nil)
       review2View.applyGradientToTopView(colours: STARGRADIENT, locations: nil)
       review3View.applyGradientToTopView(colours: STARGRADIENT, locations: nil)
       valueLabel.text = GlobalData.sharedInstance.language(key: "value")
       priceLabel.text = GlobalData.sharedInstance.language(key: "price")
       qualityLabel.text = GlobalData.sharedInstance.language(key: "quality")
       mainView.layer.cornerRadius = 5;
       mainView.layer.borderWidth = 1.0
       mainView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

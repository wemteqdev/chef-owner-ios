//
//  SellerRatingViewCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerRatingViewCell: UITableViewCell {
    
    @IBOutlet weak var averageStarImage: UIImageView!
    @IBOutlet weak var avgRatingValue: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var percentageValue: UILabel!
    @IBOutlet weak var makeReviewButton: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var priceRatingImage: UIImageView!
    @IBOutlet weak var avgPriceRatingValue: UILabel!
    @IBOutlet weak var avgPriceRatingLabel: UILabel!
    @IBOutlet weak var priceRating1Label: UILabel!
    @IBOutlet weak var priceRating1Value: UIProgressView!
    @IBOutlet weak var priceRating2Label: UILabel!
    @IBOutlet weak var priceRating2Value: UIProgressView!
    @IBOutlet weak var priceRating3Label: UILabel!
    @IBOutlet weak var priceRating3Value: UIProgressView!
    @IBOutlet weak var priceRating4Label: UILabel!
    @IBOutlet weak var priceRating4Value: UIProgressView!
    @IBOutlet weak var priceRating5Label: UILabel!
    @IBOutlet weak var priceRating5Value: UIProgressView!
    
    
    
    
    @IBOutlet weak var valueRatingImage: UIImageView!
    @IBOutlet weak var avgValueRatingValue: UILabel!
    @IBOutlet weak var avgValueRatingLabel: UILabel!
    @IBOutlet weak var valueRating1Label: UILabel!
    @IBOutlet weak var valueRating1LabelValue: UIProgressView!
    @IBOutlet weak var valueRating2Label: UILabel!
    @IBOutlet weak var valueRating2LabelValue: UIProgressView!
    @IBOutlet weak var valueRating3Label: UILabel!
    @IBOutlet weak var valueRating3LabelValue: UIProgressView!
    @IBOutlet weak var valueRating4Label: UILabel!
    @IBOutlet weak var valueRating4LabelValue: UIProgressView!
    @IBOutlet weak var valueRating5Label: UILabel!
    @IBOutlet weak var valueRating5LabelValue: UIProgressView!
    
    
    @IBOutlet weak var qualityRatingImage: UIImageView!
    @IBOutlet weak var avgQaulityRatingValue: UILabel!
    @IBOutlet weak var avgQualityRatingLabel: UILabel!
    @IBOutlet weak var qualityRating1Label: UILabel!
    @IBOutlet weak var qualityRating1LabelValue: UIProgressView!
    @IBOutlet weak var qualityRating2Label: UILabel!
    @IBOutlet weak var qualityRating2LabelValue: UIProgressView!
    @IBOutlet weak var qualityRating3Label: UILabel!
    @IBOutlet weak var qualityRating3LabelValue: UIProgressView!
    @IBOutlet weak var qualityRating4Label: UILabel!
    @IBOutlet weak var qualityRating4LabelValue: UIProgressView!
    @IBOutlet weak var qualityRating5Label: UILabel!
    @IBOutlet weak var qualityRating5LabelValue: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        priceRating1Value.progressTintColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        priceRating2Value.progressTintColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        priceRating3Value.progressTintColor = UIColor.orange
        priceRating4Value.progressTintColor = UIColor.orange
        priceRating5Value.progressTintColor = UIColor.red
        
        valueRating1LabelValue.progressTintColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        valueRating2LabelValue.progressTintColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        valueRating3LabelValue.progressTintColor = UIColor.orange
        valueRating4LabelValue.progressTintColor = UIColor.orange
        valueRating5LabelValue.progressTintColor = UIColor.red
        
        
        qualityRating1LabelValue.progressTintColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        qualityRating2LabelValue.progressTintColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        qualityRating3LabelValue.progressTintColor = UIColor.orange
        qualityRating4LabelValue.progressTintColor = UIColor.orange
        qualityRating5LabelValue.progressTintColor = UIColor.red
        
        priceRatingImage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        valueRatingImage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        qualityRatingImage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        averageStarImage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
        
        view1.layer.cornerRadius = 2.0
        view1.layer.borderWidth = 0.5
        view1.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        view2.layer.cornerRadius = 2.0
        view2.layer.borderWidth = 0.5
        view2.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        view3.layer.cornerRadius = 2.0
        view3.layer.borderWidth = 0.5
        view3.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        makeReviewButton.setTitle("makereview".localized, for: .normal)
    }
}

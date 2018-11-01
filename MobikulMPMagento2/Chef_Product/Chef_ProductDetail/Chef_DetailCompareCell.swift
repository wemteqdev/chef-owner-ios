//
//  Chef_CompareCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 14/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_DetailCompareCell: UICollectionViewCell {
    
    @IBOutlet weak var qtyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var discountLayer: UIView!
    @IBOutlet weak var discountLabel: UIButton!
    @IBOutlet weak var moq: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var addtocart: UIButton!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var reviewStar: HCSStarRatingView!
    @IBOutlet weak var reviewRatingmark: UILabel!
    @IBOutlet weak var pricevat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reviewRatingmark.layer.cornerRadius = reviewRatingmark.frame.height / 2 - 1
        reviewRatingmark.layer.masksToBounds = true
        discountLabel.isHidden = true
        discountLayer.isHidden = true
        addtocart.layer.cornerRadius = reviewRatingmark.frame.height / 2 - 1
        addtocart.layer.masksToBounds = true
        
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = UIColor.lightGray.cgColor
        
        qtyButton.layer.borderWidth = 1
        qtyButton.layer.borderColor = UIColor.lightGray.cgColor
    }

}

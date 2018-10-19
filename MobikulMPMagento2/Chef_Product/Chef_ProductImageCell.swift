//
//  Chef_ProductImageCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 17/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_ProductImageCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var addToCompareButton: UIButton!
    
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var reviewCnt: UILabel!
    
    @IBOutlet weak var starRating: HCSStarRatingView!
    @IBOutlet weak var ratingbtn: UIButton!
    
    @IBOutlet weak var price_vat: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        wishListButton.isHidden = true
        addButton.layer.cornerRadius = addButton.frame.height / 2 - 5
        addButton.layer.masksToBounds = true
        //productDescription.isHidden = true
        
        ratingbtn.layer.cornerRadius = ratingbtn.frame.height / 2 - 1
        ratingbtn.layer.masksToBounds = true
        addToCompareButton.layer.cornerRadius = addButton.frame.height / 2 - 5
        addToCompareButton.layer.masksToBounds = true
        addToCompareButton.layer.borderWidth = 1
        addToCompareButton.layer.borderColor = UIColor.lightGray.cgColor
    }

}

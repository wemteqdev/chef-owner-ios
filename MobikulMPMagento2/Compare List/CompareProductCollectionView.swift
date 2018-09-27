//
//  CompareProductCollectionView.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 25/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CompareProductCollectionView: UICollectionViewCell {
    
    
@IBOutlet weak var imageViewData: UIImageView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var ratingValue: HCSStarRatingView!
@IBOutlet weak var priceValue: UILabel!
@IBOutlet weak var deleteButton: UIButton!
@IBOutlet weak var wishListButton: UIButton!
@IBOutlet weak var addToCartButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        addToCartButton.setTitle(GlobalData.sharedInstance.language(key: "addtocart"), for: .normal)
        
    }

}

//
//  ProductImageCell.swift
//  WooCommerce
//
//  Created by Webkul on 04/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

@IBOutlet weak var productImage: UIImageView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var productPrice: UILabel!
@IBOutlet weak var specialPrice: UILabel!
@IBOutlet weak var wishListButton: UIButton!
@IBOutlet weak var addToCompareButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        specialPrice.isHidden = true
        addToCompareButton.isHidden = false
    }

}

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
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var addToCompareButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        specialPrice.isHidden = true
        wishListButton.isHidden = true
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.masksToBounds = true
        productDescription.isHidden = true
        
        addToCompareButton.layer.cornerRadius = addButton.frame.height / 2
        addToCompareButton.layer.masksToBounds = true
        addToCompareButton.layer.borderWidth = 1
        addToCompareButton.layer.borderColor = UIColor.lightGray.cgColor
    }

}

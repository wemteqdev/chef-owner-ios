//
//  ListCollectionViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 09/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    
@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var name: UILabel!
@IBOutlet weak var descriptionData: UILabel!
@IBOutlet weak var price: UILabel!

@IBOutlet weak var wishList_Button: UIButton!
@IBOutlet weak var compare_Button: UIButton!
@IBOutlet weak var specialPrice: UILabel!

var productCollectionViewModel:ProductCollectionViewModel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        compare_Button.isHidden = SHOW_COMPARE
        specialPrice.isHidden = true;
    }
    

    
  
    
    

}

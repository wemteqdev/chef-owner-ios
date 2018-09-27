//
//  ProductNameCollectionViewCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ProductNameCollectionViewCell: UICollectionViewCell {

    
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var productCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productName.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
    }

}




//
//  CategoryCell.swift
//  WooCommerce
//
//  Created by Webkul on 01/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var labelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.layer.cornerRadius = 30
        imageView?.clipsToBounds = true
        labelName.textColor = UIColor().HexToColor(hexString: "8E8E93")
        
    }

}

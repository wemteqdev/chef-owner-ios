//
//  CatalogProductImage.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 10/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CatalogProductImage: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var identifier: String  {
        return String(describing: self)
    }
    
    static var nib : UINib  {
        return UINib(nibName: identifier, bundle: nil)
    }
}

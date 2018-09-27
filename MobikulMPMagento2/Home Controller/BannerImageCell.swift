//
//  BannerImageCell.swift
//  WooCommerce
//
//  Created by Webkul on 04/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class BannerImageCell: UICollectionViewCell {

@IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView?.layer.cornerRadius = 10
        bannerImageView?.clipsToBounds = true
        //bannerImageView?.contentMode = .scaleAspectFit
        
    }

}

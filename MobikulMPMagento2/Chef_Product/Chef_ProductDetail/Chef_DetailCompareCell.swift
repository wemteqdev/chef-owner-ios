//
//  Chef_CompareCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 14/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_DetailCompareCell: UICollectionViewCell {
    
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
    }

}

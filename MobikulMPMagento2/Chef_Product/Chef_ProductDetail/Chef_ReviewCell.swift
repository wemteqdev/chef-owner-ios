//
//  Chef_ReviewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 14/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_ReviewCell: UICollectionViewCell {
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var reviewerandtime: UILabel!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var reviewRating: HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

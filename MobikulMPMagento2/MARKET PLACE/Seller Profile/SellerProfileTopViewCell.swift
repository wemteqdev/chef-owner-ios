//
//  SellerProfileTopViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 06/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerProfileTopViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var sellerProfileImage: UIImageView!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var call: UIButton!
    @IBOutlet weak var faceBook: UIButton!
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var mail: UIButton!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.applyGradientToTopView(colours: STARGRADIENT, locations: nil)
        call.layer.cornerRadius = 20;
        call.clipsToBounds = true
        faceBook.layer.cornerRadius = 20;
        faceBook.clipsToBounds = true
        twitter.layer.cornerRadius = 20;
        twitter.clipsToBounds = true
        mail.layer.cornerRadius = 20;
        mail.clipsToBounds = true
    }
}

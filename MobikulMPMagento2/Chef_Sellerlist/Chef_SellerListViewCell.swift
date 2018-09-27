//
//  Chef_SellerListViewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 19/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_SellerListViewCell: UITableViewCell {
    
    @IBOutlet weak var sellerImage: UIImageView!
    @IBOutlet weak var sellerName: UIButton!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var noOfProducts: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewMapButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        //sellerName.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        noOfProducts.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        noOfProducts.isHidden = true
        
        viewMapButton.layer.cornerRadius = 9
        viewMapButton.layer.masksToBounds = true
        
        viewAllButton.layer.cornerRadius = viewAllButton.frame.height / 2
        viewAllButton.layer.masksToBounds = true
        viewAllButton.layer.borderWidth = 1
        viewAllButton.layer.borderColor = UIColor().HexToColor(hexString: "007AFF").cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

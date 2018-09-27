//
//  SellerListViewCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerListViewCell: UITableViewCell {

    
    @IBOutlet weak var sellerImage: UIImageView!
@IBOutlet weak var sellerName: UIButton!
@IBOutlet weak var viewAllButton: UIButton!
@IBOutlet weak var noOfProducts: UILabel!
@IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sellerName.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        noOfProducts.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  TopSellingProduct.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class TopSellingProduct: UITableViewCell {
@IBOutlet weak var productName: UIButton!
@IBOutlet weak var totalproducts: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        productName.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        totalproducts.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  OrderReviewProductCell.swift
//  Magento2V4Theme
//
//  Created by kunal on 21/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class OrderReviewProductCell: UITableViewCell {

@IBOutlet weak var productName: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var qtyValue: UILabel!
@IBOutlet weak var optionValue: UILabel!
@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var subtotalValue: UILabel!
    
@IBOutlet weak var imageUrl: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        subtotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

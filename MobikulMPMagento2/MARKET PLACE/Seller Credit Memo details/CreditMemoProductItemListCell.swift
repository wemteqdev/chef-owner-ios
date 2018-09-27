//
//  CreditMemoProductItemListCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoProductItemListCell: UITableViewCell {

    
@IBOutlet weak var name: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var qtyLabelValue: UILabel!
@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
@IBOutlet weak var taxLabel: UILabel!
@IBOutlet weak var taxLabelValue: UILabel!
@IBOutlet weak var discountLabel: UILabel!
@IBOutlet weak var discountLabelValue: UILabel!
@IBOutlet weak var rowtotalLabel: UILabel!
@IBOutlet weak var rowtotalLabelValue: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        subtotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        taxLabel.text = GlobalData.sharedInstance.language(key: "tax")
        discountLabel.text = GlobalData.sharedInstance.language(key: "discount")
        rowtotalLabel.text = GlobalData.sharedInstance.language(key: "rowtotal")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

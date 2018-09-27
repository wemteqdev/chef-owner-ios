//
//  TransactionDetailsBottomCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class TransactionDetailsBottomCell: UITableViewCell {
@IBOutlet weak var orderLabel: UILabel!
@IBOutlet weak var orderLabelValue: UILabel!
@IBOutlet weak var productNameLabel: UILabel!
@IBOutlet weak var productNameLabelValue: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var qtyLabelValue: UILabel!
@IBOutlet weak var totalLabel: UILabel!
@IBOutlet weak var totalValue: UILabel!
@IBOutlet weak var totalTaxLabel: UILabel!
@IBOutlet weak var totalTaxLabelValue: UILabel!
@IBOutlet weak var totalShippingLabel: UILabel!
@IBOutlet weak var totalShippingLabelValue: UILabel!
@IBOutlet weak var commissionLabel: UILabel!
@IBOutlet weak var commissionLabelValue: UILabel!
@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderLabel.text = GlobalData.sharedInstance.language(key: "orderid")
        productNameLabel.text = GlobalData.sharedInstance.language(key: "productname")
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        totalLabel.text = GlobalData.sharedInstance.language(key: "total")
        totalTaxLabel.text = GlobalData.sharedInstance.language(key: "totaltax")
        totalShippingLabel.text = GlobalData.sharedInstance.language(key: "totalshipping")
        commissionLabel.text = GlobalData.sharedInstance.language(key: "commission")
        subtotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

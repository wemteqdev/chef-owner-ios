//
//  SellerItemsTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 06/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerItemsTableViewCell: UITableViewCell {
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var qtyLabelValue: UILabel!
@IBOutlet weak var totalLabel: UILabel!
@IBOutlet weak var totalLabelValue: UILabel!
@IBOutlet weak var admincommissionLabel: UILabel!
@IBOutlet weak var admincommissionLabelValue: UILabel!
@IBOutlet weak var vendorTotalLabel: UILabel!
@IBOutlet weak var vendorTotalLabelValue: UILabel!
@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        totalLabel.text = GlobalData.sharedInstance.language(key: "totals")
        admincommissionLabel.text = GlobalData.sharedInstance.language(key: "admincommission")
        vendorTotalLabel.text = GlobalData.sharedInstance.language(key: "vendortotal")
        subtotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

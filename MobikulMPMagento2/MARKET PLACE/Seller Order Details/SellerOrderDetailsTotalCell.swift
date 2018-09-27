//
//  SellerOrderDetailsTotalCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerOrderDetailsTotalCell: UITableViewCell {

    
@IBOutlet weak var subtaotalLabel: UILabel!
@IBOutlet weak var subtaotalLabelValue: UILabel!
    
@IBOutlet weak var shipping_handlingLabel: UILabel!
@IBOutlet weak var shipping_handlingLabelValue: UILabel!

@IBOutlet weak var discountLabel: UILabel!
@IBOutlet weak var discountLabelValue: UILabel!

@IBOutlet weak var totalTaxLabel: UILabel!
@IBOutlet weak var totalTaxValue: UILabel!

@IBOutlet weak var totalOrderAmountLabel: UILabel!
@IBOutlet weak var totalOrderAmountLabelValue: UILabel!

@IBOutlet weak var totalVendorAmountLabel: UILabel!
@IBOutlet weak var totalVendorAmountLabelValue: UILabel!

@IBOutlet weak var totalAdminCommissionLabel: UILabel!
@IBOutlet weak var totalAdminCommissionLabelValue: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subtaotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        shipping_handlingLabel.text = GlobalData.sharedInstance.language(key: "shipping_handling")
        discountLabel.text = GlobalData.sharedInstance.language(key: "discount")
        totalTaxLabel.text = GlobalData.sharedInstance.language(key: "totaltax")
        totalOrderAmountLabel.text = GlobalData.sharedInstance.language(key: "totalorderamount")
        totalVendorAmountLabel.text = GlobalData.sharedInstance.language(key: "totalvendoramount")
         totalAdminCommissionLabel.text = GlobalData.sharedInstance.language(key: "totaladmincommission")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

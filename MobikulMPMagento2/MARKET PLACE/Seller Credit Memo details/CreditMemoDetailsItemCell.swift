//
//  CreditMemoDetailsItemCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 08/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoDetailsItemCell: UITableViewCell {

@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
@IBOutlet weak var discountLabel: UILabel!
@IBOutlet weak var discountLabelValue: UILabel!
@IBOutlet weak var totalTaxLabel: UILabel!
@IBOutlet weak var totalTaxLabelValue: UILabel!
@IBOutlet weak var adjustmentRefundLabel: UILabel!
@IBOutlet weak var adjustmentRefundLabelValue: UILabel!
@IBOutlet weak var shipping_handlingLabel: UILabel!
@IBOutlet weak var shipping_handlingLabelValue: UILabel!
@IBOutlet weak var adjustmentFeeLabel: UILabel!
@IBOutlet weak var adjustmentFeeLabelValue: UILabel!
@IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var grandTotalLabelValue: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subtotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        discountLabel.text = GlobalData.sharedInstance.language(key: "discount")
        totalTaxLabel.text = GlobalData.sharedInstance.language(key: "tax")
        adjustmentRefundLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        shipping_handlingLabel.text = GlobalData.sharedInstance.language(key: "shipping_handling")
        adjustmentFeeLabel.text = GlobalData.sharedInstance.language(key: "adjustmentfee")
        grandTotalLabel.text = GlobalData.sharedInstance.language(key: "grandtotal")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

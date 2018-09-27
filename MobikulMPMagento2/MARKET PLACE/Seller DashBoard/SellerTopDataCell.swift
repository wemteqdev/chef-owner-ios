//
//  SellerTopDataCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerTopDataCell: UITableViewCell {
    
@IBOutlet weak var lifetimeSaleLabel: UILabel!
@IBOutlet weak var lifetimeSaleLabelValue: UILabel!
@IBOutlet weak var totalPayoutLabel: UILabel!
@IBOutlet weak var totalPayoutLabelValue: UILabel!
@IBOutlet weak var remainingAmountLabel: UILabel!
@IBOutlet weak var remainingAmountLabelValue: UILabel!
@IBOutlet weak var topView: GradientView!
@IBOutlet weak var secondView: UIView!
@IBOutlet weak var thirdView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lifetimeSaleLabel.text = GlobalData.sharedInstance.language(key: "lifetimesale")
        totalPayoutLabel.text = GlobalData.sharedInstance.language(key: "totalpayout")
        remainingAmountLabel.text = GlobalData.sharedInstance.language(key: "remainingamount")
      
        secondView.layer.cornerRadius = 10;
        secondView.layer.masksToBounds = true;
        secondView.layer.borderWidth = 1
        secondView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor;
        thirdView.layer.cornerRadius = 10;
        thirdView.layer.masksToBounds = true;
        thirdView.layer.borderWidth = 1
        thirdView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor;
        
    }

    override func layoutSubviews() {
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  AddressUITableViewCell.swift
//  MobikulRTL
//
//  Created by rakesh kumar on 24/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class AddressUITableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addressLabel.font = UIFont(name: REGULARFONT, size: CGFloat(14))
        //            billingAddressValue.textColor = UIColor().HexToColor(hexString: textColor)
        addressLabel.textColor = UIColor.darkGray
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        addressLabel.baselineAdjustment = .alignBaselines
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

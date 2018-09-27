//
//  ExtraCartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 29/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ExtraCartTableViewCell: UITableViewCell {
    
@IBOutlet weak var emptyCartButton: UIButton!
@IBOutlet weak var updateCartButton: UIButton!
@IBOutlet weak var applyCouponCodeLabel: UILabel!
@IBOutlet weak var couponCodeTextFeild: UITextField!
@IBOutlet weak var applyButton: UIButton!
@IBOutlet weak var cancelButton: UIButton!
@IBOutlet weak var subTotalLabel: UILabel!
@IBOutlet weak var subTotalLabelValue: UILabel!
@IBOutlet weak var taxLabel: UILabel!
@IBOutlet weak var taxLabelValue: UILabel!
@IBOutlet weak var shippingHandlingLabel: UILabel!
@IBOutlet weak var shippingHandlingLabelValue: UILabel!
@IBOutlet weak var grandTotalLabel: UILabel!
@IBOutlet weak var grandTotalLabelValue: UILabel!
@IBOutlet weak var proceedToCheckOutButton: UIButton!
@IBOutlet weak var discountLabe: UILabel!
@IBOutlet weak var discountLabelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emptyCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        updateCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        applyButton.backgroundColor = UIColor.white
        applyButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        cancelButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        proceedToCheckOutButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        
        
        
        emptyCartButton.layer.cornerRadius = 5
        emptyCartButton.clipsToBounds = true
        updateCartButton.layer.cornerRadius = 5
        updateCartButton.clipsToBounds = true
        proceedToCheckOutButton.layer.cornerRadius = 5
        proceedToCheckOutButton.clipsToBounds = true
       
        
        
        
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
  
    
    }
    
    override func layoutSubviews() {
        emptyCartButton.setTitle(GlobalData.sharedInstance.language(key: "emptycart"), for: .normal)
        updateCartButton.setTitle(GlobalData.sharedInstance.language(key: "updatecart"), for: .normal)
        applyButton.setTitle(GlobalData.sharedInstance.language(key: "apply"), for: .normal)
        cancelButton.setTitle(GlobalData.sharedInstance.language(key: "cancel"), for: .normal)
        proceedToCheckOutButton.setTitle(GlobalData.sharedInstance.language(key: "checkout"), for: .normal)
        applyCouponCodeLabel.text = GlobalData.sharedInstance.language(key: "applycouponcode")
        
    }
    
    
    
}

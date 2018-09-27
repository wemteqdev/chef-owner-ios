//
//  CartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 29/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
@IBOutlet weak var productImageView: UIImageView!
@IBOutlet weak var productNameLabelValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var optionMessage: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var subTotalLabel: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
@IBOutlet weak var moveToWishListButton: UIButton!
@IBOutlet weak var qtyValue: UILabel!
@IBOutlet weak var errorMessage: UILabel!
@IBOutlet weak var removeButton: UIButton!
@IBOutlet weak var stepperButton: UIStepper!
var myCartViewModel:MyCartViewModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        errorMessage.isHidden = true;
        priceLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        subTotalLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtyLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        optionMessage.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     override func layoutSubviews() {
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")+": "
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")+": "
        subTotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")+": "
        moveToWishListButton.setTitle(GlobalData.sharedInstance.language(key: "movetowishlist"), for: .normal)
        moveToWishListButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        removeButton.setTitle(GlobalData.sharedInstance.language(key: "remove"), for: .normal)
        removeButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        stepperButton.tintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
     }
    
    
    @IBAction func IncrementValue(_ sender: UIStepper) {
        let value =   String(format:"%d",Int(sender.value));
        qtyValue.text = value
        myCartViewModel.setQtyDataToCartModel(data: value, pos: sender.tag)
    }
    
}

//
//  ContinueToBillTableViewCell.swift
//  MobikulRTL
//
//  Created by rakesh kumar on 24/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ContinueToBillTableViewCell: UITableViewCell {

    @IBOutlet weak var grandTotalValue: UILabel!
    @IBOutlet weak var shippingValue: UILabel!
    @IBOutlet weak var subTotalValue: UILabel!
    @IBOutlet weak var grandTotalTitleLabel: UILabel!
    @IBOutlet weak var shippingTitleLabel: UILabel!
    @IBOutlet weak var subtotalTitleLabel: UILabel!
@IBOutlet weak var taxtitle: UILabel!
@IBOutlet weak var taxValue: UILabel!
@IBOutlet weak var discountTitle: UILabel!
@IBOutlet weak var discountValue: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    let globalObjectContinueToBill = GlobalData();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        continueBtn.backgroundColor =  UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueBtn.setTitle(GlobalData.sharedInstance.language(key:"continue"), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

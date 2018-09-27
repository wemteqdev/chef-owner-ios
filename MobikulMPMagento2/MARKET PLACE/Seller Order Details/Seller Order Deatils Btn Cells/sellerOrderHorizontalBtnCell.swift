//
//  sellerOrderHorizontalBtnCell.swift
//  MobikulMPMagento2
//
//  Created by himanshu on 29/04/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class sellerOrderHorizontalBtnCell: UITableViewCell {
    
    @IBOutlet weak var viewInvoice: UIButton!
    @IBOutlet weak var viewshipment: UIButton!
    @IBOutlet weak var viewRefunds: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewInvoice.setTitle(GlobalData.sharedInstance.language(key: "invoice"), for: .normal)
        viewshipment.setTitle(GlobalData.sharedInstance.language(key: "shipment"), for: .normal)
        viewRefunds.setTitle(GlobalData.sharedInstance.language(key: "refund"), for: .normal)
        
        viewInvoice.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        viewshipment.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        viewRefunds.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        viewInvoice.setTitleColor(UIColor.white, for: .normal)
        viewshipment.setTitleColor(UIColor.white, for: .normal)
        viewRefunds.setTitleColor(UIColor.white, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static var identifier: String   {
        return String(describing: self)
    }
    
    static var nib: UINib   {
        return UINib(nibName: identifier, bundle: nil)
    }
}

//
//  MyOrderTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul on 18/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
@IBOutlet weak var orderLabel: UILabel!
@IBOutlet weak var orderId: UILabel!
@IBOutlet weak var statusMessage: UILabel!
@IBOutlet weak var placedonLabel: UILabel!
@IBOutlet weak var placedOnDate: UILabel!
@IBOutlet weak var orderDetails: UILabel!
@IBOutlet weak var mainView: UIView!
@IBOutlet weak var viewOrderButton: UIButton!
@IBOutlet weak var shipToLabel: UILabel!
@IBOutlet weak var shipToValue: UILabel!
@IBOutlet weak var reorderButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        orderLabel.text = GlobalData.sharedInstance.language(key: "orderid")
        placedonLabel.text = GlobalData.sharedInstance.language(key: "placeon")
        shipToLabel.text = GlobalData.sharedInstance.language(key: "shipto")
        viewOrderButton.setTitle(GlobalData.sharedInstance.language(key: "vieworder"), for: .normal)
        reorderButton.setTitle(GlobalData.sharedInstance.language(key: "reorder"), for: .normal)
        
        placedonLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
    
        shipToLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        viewOrderButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        reorderButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        statusMessage.layer.cornerRadius = 2;
        statusMessage.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

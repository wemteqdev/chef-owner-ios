//
//  OrderInfoItemList.swift
//  OpenCartMpV3
//
//  Created by kunal on 05/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class OrderInfoItemList: UITableViewCell {
    
    
@IBOutlet weak var mainView: UIView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var dynamicView: UIView!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var qtyValue: UILabel!
@IBOutlet weak var subtaotalLabel: UILabel!
@IBOutlet weak var subtotalValue: UILabel!
@IBOutlet weak var dynamicViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var productValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")+":"
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        subtaotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")+" :"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

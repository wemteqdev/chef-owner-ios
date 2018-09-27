//
//  MyProductListViewCell.swift
//  ShangMarket
//
//  Created by kunal on 27/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class MyProductListViewCell: UITableViewCell {
    
@IBOutlet weak var priductImage: UIImageView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var typeLabel: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var typeLabelValue: UILabel!
@IBOutlet weak var statusLabel: UILabel!
@IBOutlet weak var earnedAmountLabel: UILabel!
@IBOutlet weak var statusLabelValue: UILabel!
@IBOutlet weak var earnedAmountLabelValue: UILabel!
@IBOutlet weak var qtyConfirmedLabel: UILabel!
@IBOutlet weak var qtypendingLabel: UILabel!
@IBOutlet weak var qtysoldLabel: UILabel!
@IBOutlet weak var qtyConfirmedLabelValue: UILabel!
@IBOutlet weak var qtypendingLabelValue: UILabel!
@IBOutlet weak var qtysoldLabelValue: UILabel!
@IBOutlet weak var editButton: UIButton!
@IBOutlet weak var deleteButton: UIButton!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")
        typeLabel.text = GlobalData.sharedInstance.language(key: "type")
        statusLabel.text = GlobalData.sharedInstance.language(key: "status")
        earnedAmountLabel.text = GlobalData.sharedInstance.language(key: "earnedamount")
        qtyConfirmedLabel.text = GlobalData.sharedInstance.language(key: "qtyconfirmed")
        qtypendingLabel.text = GlobalData.sharedInstance.language(key: "qtypending")
        qtysoldLabel.text = GlobalData.sharedInstance.language(key: "qtysold")
        
        priceLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        typeLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        statusLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        earnedAmountLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtyConfirmedLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtysoldLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtypendingLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
       
        editButton.setTitle(GlobalData.sharedInstance.language(key: "edit"), for: .normal)
        deleteButton.setTitle(GlobalData.sharedInstance.language(key: "delete"), for: .normal)
        
        editButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        deleteButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  StatusOrderTableViewCell.swift
//  Magento2V4Theme
//
//  Created by kunal on 14/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class StatusOrderTableViewCell: UITableViewCell {

    
@IBOutlet weak var placedOnLabel: UILabel!
@IBOutlet weak var placeOnDateValue: UILabel!
@IBOutlet weak var statusMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placedOnLabel.text = GlobalData.sharedInstance.language(key: "placeon")
        placedOnLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        statusMessage.layer.cornerRadius = 2;
        statusMessage.layer.masksToBounds = true
        statusMessage.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

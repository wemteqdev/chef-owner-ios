//
//  CustomerInfoTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul on 28/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CustomerInfoTableViewCell: UITableViewCell {
@IBOutlet weak var customerNameValue: UILabel!
@IBOutlet weak var emailValue: UILabel!
@IBOutlet weak var customerNameLabel: UILabel!
@IBOutlet weak var emailLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customerNameLabel.text = GlobalData.sharedInstance.language(key: "customername")
        emailLabel.text = GlobalData.sharedInstance.language(key: "email")
    }
}

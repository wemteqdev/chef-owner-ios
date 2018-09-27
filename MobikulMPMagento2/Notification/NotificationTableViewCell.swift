//
//  NotificationTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 04/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    
@IBOutlet weak var titleText: UILabel!
@IBOutlet weak var contentsText: UILabel!
@IBOutlet weak var bannerIMage: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

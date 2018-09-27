//
//  PaymentTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul on 28/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var roundImageView: UIImageView!
    @IBOutlet weak var methodDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundImageView.layer.cornerRadius = 10
        roundImageView.layer.masksToBounds = true
        roundImageView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        roundImageView.layer.borderWidth = 1.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

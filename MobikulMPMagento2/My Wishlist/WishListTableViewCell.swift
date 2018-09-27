//
//  WishListTableViewCell.swift
//  MobikulRTL
//
//  Created by shobhit on 18/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var startRatings: HCSStarRatingView!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

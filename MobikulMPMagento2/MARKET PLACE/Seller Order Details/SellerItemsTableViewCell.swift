//
//  SellerItemsTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 06/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var itemCellWidth:NSLayoutConstraint!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var qtyLabelValue: UILabel!
@IBOutlet weak var totalLabelValue: UILabel!
@IBOutlet weak var admincommissionLabelValue: UILabel!
@IBOutlet weak var vendorTotalLabelValue: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
   @IBOutlet weak var totalLabels: UILabel!
   @IBOutlet weak var packSizeLable: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        totalLabels.isHidden = true
       totalLabelValue.isHidden = true
        vendorTotalLabelValue.isHidden = true
        admincommissionLabelValue.isHidden = true
        
        infoLabel.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        
        // Configure the view for the selected state
    }
    
}

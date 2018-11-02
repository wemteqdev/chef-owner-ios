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
        infoView.layer.borderWidth = 1
        infoView.layer.borderColor = UIColor.lightGray.cgColor
        
        totalLabels.layer.borderWidth = 1
        totalLabels.layer.borderColor = UIColor.lightGray.cgColor
        
        infoLabel.layer.borderWidth = 1
        infoLabel.layer.borderColor = UIColor.lightGray.cgColor
        infoLabel.isHidden = true
        priceLabelValue.layer.borderWidth = 1
        priceLabelValue.layer.borderColor = UIColor.lightGray.cgColor
        
        qtyLabelValue.layer.borderWidth = 1
        qtyLabelValue.layer.borderColor = UIColor.lightGray.cgColor
        
        totalLabelValue.layer.borderWidth = 1
        totalLabelValue.layer.borderColor = UIColor.lightGray.cgColor
        
        admincommissionLabelValue.layer.borderWidth = 1
        admincommissionLabelValue.layer.borderColor = UIColor.lightGray.cgColor
        
        vendorTotalLabelValue.layer.borderWidth = 1
        vendorTotalLabelValue.layer.borderColor = UIColor.lightGray.cgColor
        
        subtotalLabelValue.layer.borderWidth = 1
        subtotalLabelValue.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        
        // Configure the view for the selected state
    }
    
}

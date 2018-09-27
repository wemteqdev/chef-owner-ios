//
//  CreditMemoListViewCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoListViewCell: UITableViewCell {

@IBOutlet weak var creditmemosLabel: UILabel!
@IBOutlet weak var creditmemosLabelValue: UILabel!
@IBOutlet weak var billTonameLabel: UILabel!
@IBOutlet weak var billTonameLabelValue: UILabel!
@IBOutlet weak var createdAtLabel: UILabel!
@IBOutlet weak var createdAtLabelValue: UILabel!
@IBOutlet weak var ststusLabel: UILabel!
@IBOutlet weak var ststusLabelValue: UILabel!
@IBOutlet weak var amountLabel: UILabel!
@IBOutlet weak var amountLabelValue: UILabel!
    
    @IBOutlet weak var viewButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        creditmemosLabel.text = GlobalData.sharedInstance.language(key:"creditmemos");
        billTonameLabel.text = GlobalData.sharedInstance.language(key:"billtoname");
        createdAtLabel.text = GlobalData.sharedInstance.language(key:"createdat");
        ststusLabel.text = GlobalData.sharedInstance.language(key:"status");
        amountLabel.text = GlobalData.sharedInstance.language(key:"amount");
       
        viewButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        viewButton.setTitle(GlobalData.sharedInstance.language(key: "view"), for: .normal)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

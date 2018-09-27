//
//  TansactionListView.swift
//  MobikulMPMagento2
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class TansactionListView: UITableViewCell {
@IBOutlet weak var transactionIdLabel: UILabel!
@IBOutlet weak var transactionIdLabelValue: UILabel!
@IBOutlet weak var dateLabel: UILabel!
@IBOutlet weak var dateLabelValue: UILabel!
@IBOutlet weak var commentMessageLabel: UILabel!
@IBOutlet weak var commentMessageLabelValue: UILabel!
@IBOutlet weak var transactionAmount: UILabel!
@IBOutlet weak var transactionAmountValue: UILabel!
@IBOutlet weak var viewButton: UIButton!
@IBOutlet weak var mainView: UIView!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transactionIdLabel.text = GlobalData.sharedInstance.language(key: "transactionid")
        dateLabel.text = GlobalData.sharedInstance.language(key: "date")
        commentMessageLabel.text = GlobalData.sharedInstance.language(key: "commentmessage")
        transactionAmount.text = GlobalData.sharedInstance.language(key: "transactionamount")
        
        dateLabel.textColor  = UIColor().HexToColor(hexString: LIGHTGREY)
        
        dateLabelValue.textColor  = UIColor().HexToColor(hexString: LIGHTGREY)
        commentMessageLabel.textColor  = UIColor().HexToColor(hexString: LIGHTGREY)
        commentMessageLabelValue.textColor  = UIColor().HexToColor(hexString: LIGHTGREY)
        transactionAmount.textColor  = UIColor().HexToColor(hexString: LIGHTGREY)
        transactionAmountValue.textColor  = UIColor().HexToColor(hexString: LIGHTGREY)
        viewButton.setTitle(GlobalData.sharedInstance.language(key: "view"), for: .normal)
        viewButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

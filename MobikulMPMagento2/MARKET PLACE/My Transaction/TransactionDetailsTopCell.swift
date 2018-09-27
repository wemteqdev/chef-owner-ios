//
//  TransactionDetailsTopCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class TransactionDetailsTopCell: UITableViewCell {
@IBOutlet weak var dateLabel: UILabel!
@IBOutlet weak var dateValue: UILabel!
@IBOutlet weak var amountLabel: UILabel!
@IBOutlet weak var amountValue: UILabel!
@IBOutlet weak var typeLabel: UILabel!
@IBOutlet weak var typeValue: UILabel!
@IBOutlet weak var methodLabel: UILabel!
@IBOutlet weak var methodValue: UILabel!
@IBOutlet weak var commentLabel: UILabel!
@IBOutlet weak var commentValue: UILabel!
@IBOutlet weak var mainView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        dateLabel.text = GlobalData.sharedInstance.language(key: "date")
        typeLabel.text = GlobalData.sharedInstance.language(key: "type")
        amountLabel.text = GlobalData.sharedInstance.language(key: "amount")
        
        methodLabel.text = GlobalData.sharedInstance.language(key: "method")
        commentLabel.text = GlobalData.sharedInstance.language(key: "comment")
        
        dateLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        typeLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        amountLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        methodLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        commentLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

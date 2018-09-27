//
//  AddressViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 15/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {

@IBOutlet weak var addressValue: UILabel!
@IBOutlet weak var editButton: UIButton!
@IBOutlet weak var deleteButton: UIButton!
@IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        editButton.setTitle(GlobalData.sharedInstance.language(key: "editaddress"), for: .normal)
        deleteButton.setTitle("/ "+GlobalData.sharedInstance.language(key: "deleteaddress"), for: .normal)
        editButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        deleteButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

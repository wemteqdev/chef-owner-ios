//
//  AddreessViewCell2.swift
//  Magento2V4Theme
//
//  Created by kunal on 13/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class AddreessViewCell2: UITableViewCell {
    
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

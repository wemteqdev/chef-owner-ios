//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
@IBOutlet weak var profileImage: UIImageView!
@IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 20;
        profileImage.layer.masksToBounds = true
        profileImage.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

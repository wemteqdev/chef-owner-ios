//
//  ProfileTableViewCell.swift
//  Magento2V4Theme
//
//  Created by kunal on 10/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class OwnerProfileTableViewCell: UITableViewCell {

@IBOutlet weak var profileImage: UIImageView!
@IBOutlet weak var profileName: UILabel!
@IBOutlet weak var profileEmail: UILabel!
@IBOutlet weak var profileBannerImage: UIImageView!
@IBOutlet weak var visualView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 35;
        profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

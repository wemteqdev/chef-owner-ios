//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ChefsCell: UITableViewCell {
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var restaruantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chefImage.layer.cornerRadius = 20;
        chefImage.layer.masksToBounds = true
        chefImage.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

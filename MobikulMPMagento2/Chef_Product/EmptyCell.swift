//
//  EmptyCell.swift
//  MobikulMPMagento2
//
//  Created by andonina on 10/26/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

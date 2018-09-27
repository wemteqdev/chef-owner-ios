//
//  sellerOrderVerticalBtnCell.swift
//  MobikulMPMagento2
//
//  Created by himanshu on 29/04/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class sellerOrderVerticalBtnCell: UITableViewCell {

    @IBOutlet weak var verticalBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        verticalBtn.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        verticalBtn.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier: String   {
        return String(describing: self)
    }
    
    static var nib: UINib   {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

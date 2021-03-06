//
//  Chef_MyOrderTableViewCellDesign.swift
//  MobikulMPMagento2
//
//  Created by Othello on 20/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_MyOrderTableViewCellDesign: UITableViewCell {
    @IBOutlet weak var statusButton:UIButton!
    @IBOutlet weak var placedonDate:UILabel!
    @IBOutlet weak var orderId:UILabel!
    @IBOutlet weak var ordertotal:UILabel!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var chefName: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var chefLable: UILabel!
    @IBOutlet weak var restaurant: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        chefLable.isHidden = true
        restaurant.isHidden = true
        chefName.isHidden = true
        restaurantLabel.isHidden = true
        
        borderView.backgroundColor = UIColor(patternImage: UIImage(named: "dot_style")!)
        statusButton.layer.cornerRadius = 13
        statusButton.layer.masksToBounds = true
        statusButton.layer.borderWidth = 1
        statusButton.layer.borderColor = UIColor().HexToColor(hexString: "FF9D11").cgColor
    statusButton.setTitleColor(UIColor().HexToColor(hexString: "FF9D11"), for: .normal)
        
        statusButton.backgroundColor = UIColor(red: 1, green: 157/255, blue:17/255, alpha: 0.3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

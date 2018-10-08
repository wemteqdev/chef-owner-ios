//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class RestaurantsCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var restaurantId:Int = 0;
    var delegate: removeFromOwnerHandlerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantImage.layer.cornerRadius = 20;
        restaurantImage.layer.masksToBounds = true
        restaurantImage.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        removeButton.layer.cornerRadius = 10;
        removeButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeButtonClick(_ sender: Any) {
        delegate.removeButtonClick(id: self.restaurantId);
    }
}

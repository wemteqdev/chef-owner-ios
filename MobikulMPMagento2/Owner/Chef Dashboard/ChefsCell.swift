//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

@objc protocol removeFromOwnerHandlerDelegate: class {
    func removeButtonClick(id:Int)
}

class ChefsCell: UITableViewCell {
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var restaruantName: UILabel!
    @IBOutlet weak var removeChefButton: UIButton!
    
    var chefId:Int = 0;
    var delegate: removeFromOwnerHandlerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chefImage.layer.cornerRadius = 20;
        chefImage.layer.masksToBounds = true
        chefImage.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        removeChefButton.layer.cornerRadius = 10;
        removeChefButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeChefButtonClick(_ sender: Any) {
        delegate.removeButtonClick(id: self.chefId);
    }
}

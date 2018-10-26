//
//  Chef_SuperCartCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 09/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_SuperCartCell: UITableViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var moqbtn: UIButton!
    @IBOutlet weak var pricewithsub: UILabel!
    @IBOutlet weak var ratingStarView: HCSStarRatingView!
    @IBOutlet weak var ratingStar: UIButton!
    @IBOutlet var supplierName: UILabel!
    @IBOutlet var subtotal: UILabel!
    @IBOutlet var reviewLabel: UILabel!

    @IBOutlet weak var qtyView: UIView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var qtyButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var errorMsg: UILabel!
    @IBOutlet var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        errorMsg.isHidden = true;
        qtyButton.layer.borderColor = UIColor().HexToColor(hexString: "9A9A9A").cgColor
        qtyButton.layer.borderWidth = 1
        minusButton.layer.borderColor = UIColor().HexToColor(hexString: "9A9A9A").cgColor
        minusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor().HexToColor(hexString: "9A9A9A").cgColor
        plusButton.layer.borderWidth = 1
        deleteButton.isHidden = true
        moqbtn.layer.borderColor = UIColor().HexToColor(hexString: "1AA33D").cgColor
        moqbtn.layer.borderWidth = 1
        moqbtn.layer.cornerRadius = moqbtn.frame.height/2 - 2
        moqbtn.layer.masksToBounds = true
        
        ratingStar.layer.cornerRadius = ratingStar.frame.height/2 - 2
        ratingStar.layer.masksToBounds = true
        
    }
}

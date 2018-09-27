//
//  Chef_ListCollectionViewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 17/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionData: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var wishList_Button: UIButton!
    @IBOutlet weak var compare_Button: UIButton!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var productCollectionViewModel:ProductCollectionViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        compare_Button.isHidden = SHOW_COMPARE
        wishList_Button.isHidden = true
        specialPrice.isHidden = true;
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.masksToBounds = true
        
        compare_Button.layer.cornerRadius = addButton.frame.height / 2
        compare_Button.layer.masksToBounds = true
        compare_Button.layer.borderWidth = 1
        compare_Button.layer.borderColor = UIColor.lightGray.cgColor
    }

}

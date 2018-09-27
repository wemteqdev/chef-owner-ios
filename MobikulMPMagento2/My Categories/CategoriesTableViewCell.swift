//
//  CategoriesTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 24/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

//@IBOutlet weak var imageData: UIImageView!
@IBOutlet weak var backgroundImageView: UIImageView!
@IBOutlet weak var categoryName: UILabel!
@IBOutlet var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.masksToBounds = true
        //categoryName.textColor = UIColor.random()
    }

    override func layoutSubviews() {

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

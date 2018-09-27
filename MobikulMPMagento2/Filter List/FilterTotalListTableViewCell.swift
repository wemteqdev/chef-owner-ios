//
//  FilterTotalListTableViewCell.swift
//  MobikulRTL
//
//  Created by rakesh kumar on 24/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class FilterTotalListTableViewCell: UITableViewCell {

// MARK: filtertotal
    @IBOutlet weak var listNameLabel: UILabel!
    
    @IBOutlet weak var radioBtnImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        radioBtnImgView.layer.borderWidth = 1
        radioBtnImgView.layer.borderColor = UIColor.black.cgColor
        radioBtnImgView.clipsToBounds = true
        radioBtnImgView.layer.cornerRadius = radioBtnImgView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

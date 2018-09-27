//
//  AddProductViewCell.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class AddProductViewCell: UITableViewCell {

    
@IBOutlet weak var productImage: UIImageView!
@IBOutlet weak var name: UILabel!
 @IBOutlet weak var price: UILabel!
@IBOutlet weak var attributesetValue: UILabel!
@IBOutlet weak var statusValue: UILabel!
@IBOutlet weak var typeValue: UILabel!
@IBOutlet weak var skuValue: UILabel!
@IBOutlet weak var switchValue: UISwitch!
@IBOutlet weak var mainView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderWidth = 0.5
        mainView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).withAlphaComponent(0.7).cgColor
        mainView.layer.cornerRadius = 5;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func switchClick(_ sender: UISwitch) {
      
    }
    
    
    
}

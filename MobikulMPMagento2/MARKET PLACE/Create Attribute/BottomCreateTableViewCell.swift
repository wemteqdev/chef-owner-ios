//
//  BottomCreateTableViewCell.swift
//  ShangMarket
//
//  Created by kunal on 03/04/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class BottomCreateTableViewCell: UITableViewCell {

@IBOutlet weak var removeButton: UIButton!
@IBOutlet weak var adminField: SkyFloatingLabelTextField!
@IBOutlet weak var defaultStoreViewField: SkyFloatingLabelTextField!
@IBOutlet weak var positionField: SkyFloatingLabelTextField!
@IBOutlet weak var isdefaultLabel: UILabel!
@IBOutlet weak var isDefaultSwitch: UISwitch!
@IBOutlet weak var mainView: UIView!
var createAttributeViewModel:CreateAttributeViewModel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        mainView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func AdminFieldClick(_ sender: SkyFloatingLabelTextField) {
        createAttributeViewModel.setBottomCreateAdminValue(pos: sender.tag, Value: sender.text!)
    }
    
    
    @IBAction func storeViewClick(_ sender: SkyFloatingLabelTextField) {
        createAttributeViewModel.setBottomCreateStoreValue(pos: sender.tag, Value: sender.text!)
    }
    
    
    @IBAction func positionClick(_ sender: SkyFloatingLabelTextField) {
        createAttributeViewModel.setBottomCreatePositionValue(pos: sender.tag, Value: sender.text!)
    }
    
    
    @IBAction func isdefaultClick(_ sender: UISwitch) {
        if sender.isOn{
            createAttributeViewModel.setBottomCreateIsdefaultValue(pos: sender.tag, Value: "on")
        }else{
            createAttributeViewModel.setBottomCreateIsdefaultValue(pos: sender.tag, Value: "off")
        }
        
        
    }
    
}

//
//  TopCreateCell.swift
//  ShangMarket
//
//  Created by kunal on 03/04/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class TopCreateCell: UITableViewCell {
@IBOutlet weak var createAttributeLabel: UILabel!
@IBOutlet weak var attributeCodeValueField: SkyFloatingLabelTextField!
@IBOutlet weak var attributeLabelField: SkyFloatingLabelTextField!
@IBOutlet weak var valuesrequiredLabel: UILabel!
@IBOutlet weak var addanotherButton: UIButton!
@IBOutlet weak var valueChangeSwitch: UISwitch!
var createAttributeViewModel:CreateAttributeViewModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addanotherButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for:.normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func attributeChangeCodeValue(_ sender: SkyFloatingLabelTextField) {
        createAttributeViewModel.setAttributeCodeValue(value: sender.text!)
    }
    
    
    @IBAction func AttributeLabelValue(_ sender: SkyFloatingLabelTextField) {
        createAttributeViewModel.setAttributeLabelValue(value: sender.text!)
    }
    
    @IBAction func valueChangeClick(_ sender: UISwitch) {
        if sender.isOn{
            createAttributeViewModel.setValueRequired(value: "1")
        }else{
            createAttributeViewModel.setValueRequired(value: "0")
        }
        
    }
    
    
    
}

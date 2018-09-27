//
//  CreateCreditMemoListItemCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 08/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreateCreditMemoListItemCell: UITableViewCell {

@IBOutlet weak var productName: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var priceLabelValue: UILabel!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var qtyLabelValue: UILabel!
@IBOutlet weak var refundToStockLabel: UILabel!
@IBOutlet weak var switchButton: UISwitch!
@IBOutlet weak var quantityToRefundLabel: UILabel!
@IBOutlet weak var refundTextField: UITextField!
@IBOutlet weak var subtotatalLabel: UILabel!
@IBOutlet weak var subtotatalLabelValue: UILabel!
@IBOutlet weak var taxLabel: UILabel!
@IBOutlet weak var taxLabelValue: UILabel!
@IBOutlet weak var disscountLabel: UILabel!
@IBOutlet weak var disscountLabelValue: UILabel!
@IBOutlet weak var rowTotalLabekl: UILabel!
@IBOutlet weak var rowTotalLabeklValue: UILabel!
var createCreditMemoListViewModel:CreateCreditMemoListViewModel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabel.text = GlobalData.sharedInstance.language(key: "price")
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        refundToStockLabel.text = GlobalData.sharedInstance.language(key: "refundstock")
        quantityToRefundLabel.text = GlobalData.sharedInstance.language(key: "quantitytorefund")
        subtotatalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        taxLabel.text = GlobalData.sharedInstance.language(key: "tax")
        disscountLabel.text = GlobalData.sharedInstance.language(key: "discount")
        rowTotalLabekl.text = GlobalData.sharedInstance.language(key: "rowtotal")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    @IBAction func switchClick(_ sender: UISwitch) {
        if sender.isOn{
            createCreditMemoListViewModel.setReturnToStockValue(data: "1", pos: sender.tag)
        }else{
            createCreditMemoListViewModel.setReturnToStockValue(data: "0", pos: sender.tag)
        }
   
        
    }
    
    
    @IBAction func textFieldClick(_ sender: UITextField) {
       createCreditMemoListViewModel.setqty_To_RefundValue(data: sender.text!, pos: sender.tag)
    }
    
    
    
    
}

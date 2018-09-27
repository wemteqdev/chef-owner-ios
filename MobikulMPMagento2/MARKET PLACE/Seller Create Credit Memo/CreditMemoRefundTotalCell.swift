//
//  CreditMemoRefundTotalCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 09/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoRefundTotalCell: UITableViewCell {

@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var subtotalLabelValue: UILabel!
@IBOutlet weak var discountLabel: UILabel!
@IBOutlet weak var discountLabelValue: UILabel!
@IBOutlet weak var totalTaxLabel: UILabel!
@IBOutlet weak var totalTaxLabelValue: UILabel!
@IBOutlet weak var refundShippingLabel: UILabel!
@IBOutlet weak var refundShippingField: UITextField!
@IBOutlet weak var adjustmentRefundLabel: UILabel!
@IBOutlet weak var adjustmentRefundField: UITextField!
@IBOutlet weak var adjustmentfeeLabel: UILabel!
@IBOutlet weak var adjustmentfeeField: UITextField!
@IBOutlet weak var grandTotalLabel: UILabel!
@IBOutlet weak var grandTotalLabelValue: UILabel!
@IBOutlet weak var switch1: UISwitch!
@IBOutlet weak var appendCommentLAbel: UILabel!
@IBOutlet weak var switch2: UISwitch!
@IBOutlet weak var visibleonFrontEndLabel: UILabel!
@IBOutlet weak var switch3: UISwitch!
@IBOutlet weak var emailcopyofCreditMemoLabel: UILabel!
@IBOutlet weak var refundButton: UIButton!
var appendCommentValue:String = "0"
var visibleOnFrontEndValue = "0"
var emailCopyoffrontend:String = "0"
var delegate:CreateCreditMemoDelegate!
@IBOutlet weak var refundOnlineButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switch1.isEnabled = false
        subtotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")
        discountLabel.text = GlobalData.sharedInstance.language(key: "discount")
        totalTaxLabel.text = GlobalData.sharedInstance.language(key: "tax")
        refundShippingLabel.text = GlobalData.sharedInstance.language(key: "refundshipping")
        
        adjustmentRefundLabel.text = GlobalData.sharedInstance.language(key: "adjustmentrefund")
        adjustmentfeeLabel.text = GlobalData.sharedInstance.language(key: "adjustmentfee")
        
        grandTotalLabel.text = GlobalData.sharedInstance.language(key: "grandtotal")
        
        appendCommentLAbel.text = GlobalData.sharedInstance.language(key: "appendcomment")
        
        visibleonFrontEndLabel.text = GlobalData.sharedInstance.language(key: "visibleonnfrontend")
        
        emailcopyofCreditMemoLabel.text = GlobalData.sharedInstance.language(key: "emailcopyofcreditmemo")
        refundButton.setTitle(GlobalData.sharedInstance.language(key: "refundoffline"), for: .normal)
        refundButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
    
        
        refundOnlineButton.setTitle(GlobalData.sharedInstance.language(key: "refund"), for: .normal)
        refundOnlineButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func switch1Click(_ sender: UISwitch) {
        if sender.isOn{
            appendCommentValue = "1"
        }else{
            appendCommentValue = "0"
        }
        
        
        
    }
    
    @IBAction func switch2Click(_ sender: UISwitch) {
        if sender.isOn{
            visibleOnFrontEndValue = "1"
            
        }else{
            visibleOnFrontEndValue = "0"
        }
    }
    
    
    
    @IBAction func switch3Click(_ sender: UISwitch) {
        if sender.isOn{
            switch1.isEnabled  = true
            emailCopyoffrontend = "1"
        }else{
            switch1.isEnabled  = false
            emailCopyoffrontend = "0"
        }
    }
    
    
    
    
    @IBAction func refundClick(_ sender: Any) {
        delegate.getdetailsValue(offline: "1", refundShipping: self.refundShippingField.text!, adjustmentRefund: self.adjustmentRefundField.text!, adjustmentFee: self.adjustmentfeeField.text!, appendCommentValue: appendCommentValue, visibleonfrontendValue: visibleOnFrontEndValue, emailCopyValue: emailCopyoffrontend)
    }
    
    
    @IBAction func refundOnlineClick(_ sender: UIButton) {
        delegate.getdetailsValue(offline: "0", refundShipping: self.refundShippingField.text!, adjustmentRefund: self.adjustmentRefundField.text!, adjustmentFee: self.adjustmentfeeField.text!, appendCommentValue: appendCommentValue, visibleonfrontendValue: visibleOnFrontEndValue, emailCopyValue: emailCopyoffrontend)
    }
    
    
    
    
    
    
    
    
    
}

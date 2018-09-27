//
//  SellerOrderDetailsTopCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 06/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerOrderDetailsTopCell: UITableViewCell {
    @IBOutlet weak var creditMemoButton: UIButton!
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet weak var createInvoiceButton: UIButton!
    @IBOutlet weak var createShipmenntButton: UIButton!
    @IBOutlet weak var cancelItem: UIButton!
    @IBOutlet weak var invoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var shipmentHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewInvoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var viewshipmentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRefundsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewInvoice: UIButton!
    @IBOutlet weak var viewshipment: UIButton!
    @IBOutlet weak var viewRefunds: UIButton!
    @IBOutlet weak var refundHeight: NSLayoutConstraint!
    @IBOutlet weak var mailHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        creditMemoButton.setTitle(GlobalData.sharedInstance.language(key: "creditmemo"), for: .normal)
        sendMailButton.setTitle(GlobalData.sharedInstance.language(key: "sendmail"), for: .normal)
        createInvoiceButton.setTitle(GlobalData.sharedInstance.language(key: "createinvoice"), for: .normal)
        createShipmenntButton.setTitle(GlobalData.sharedInstance.language(key: "createshipment"), for: .normal)
        cancelItem.setTitle(GlobalData.sharedInstance.language(key: "cancel"), for: .normal)
        viewInvoice.setTitle(GlobalData.sharedInstance.language(key: "invoice"), for: .normal)
        viewshipment.setTitle(GlobalData.sharedInstance.language(key: "shipment"), for: .normal)
        viewRefunds.setTitle(GlobalData.sharedInstance.language(key: "refund"), for: .normal)
        
        
        
        creditMemoButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        sendMailButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        cancelItem.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        createInvoiceButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        createShipmenntButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        creditMemoButton.setTitleColor(UIColor.white, for: .normal)
        sendMailButton.setTitleColor(UIColor.white, for: .normal)
        cancelItem.setTitleColor(UIColor.white, for: .normal)
        createInvoiceButton.setTitleColor(UIColor.white, for: .normal)
        createShipmenntButton.setTitleColor(UIColor.white, for: .normal)
        
        invoiceHeight.constant = 0
        shipmentHeight.constant = 0
        cancelHeight.constant = 0
        refundHeight.constant = 0
        mailHeight.constant = 0
        
        creditMemoButton.isHidden = true;
        sendMailButton.isHidden = true;
        cancelItem.isHidden = true;
        createInvoiceButton.isHidden = true;
        createShipmenntButton.isHidden = true;
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

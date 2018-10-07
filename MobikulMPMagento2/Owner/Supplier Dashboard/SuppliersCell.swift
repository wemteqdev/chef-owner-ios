//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

@objc protocol supplierViewControllerHandlerDelegate: class {
    func viewMapClick(id:String)
    func browseCategory(id: Int, name: String)
    func signupSupplier(id:Int)
}

class SuppliersCell: UITableViewCell {
    @IBOutlet weak var supplierImage: UIImageView!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var restaruantName: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    
    var delegate: supplierViewControllerHandlerDelegate!
    var status = 0;
    var supplierId = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        supplierImage.layer.cornerRadius = 20;
        supplierImage.layer.masksToBounds = true
        supplierImage.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        viewMapButton.layer.cornerRadius = 10;
        statusButton.layer.cornerRadius = 20;
        statusButton.layer.masksToBounds = true
        statusButton.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        statusButton.layer.cornerRadius = 10;
    }

    @IBAction func statusButtonClicked(_ sender: Any) {
        if (status == 0) { //approve
            delegate.signupSupplier(id: supplierId);
        } else {
            delegate.browseCategory(id: supplierId, name: supplierName.text!);
        }
    }
    
    @IBAction func viewMapButtonClicked(_ sender: Any) {
        delegate.viewMapClick(id: "dd");
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

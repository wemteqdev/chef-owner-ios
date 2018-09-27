//
//  EmptyNewAddressView.swift
//  WooCommerce
//
//  Created by Webkul on 09/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class EmptyNewAddressView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var emptyImages: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("EmptyNewAddress", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addressButton.layer.cornerRadius = 5;
        addressButton.layer.masksToBounds = true
        addressButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
    }    
}

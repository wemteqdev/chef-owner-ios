//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class OrderViewCell: UIView {
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderDescription: UILabel!
    @IBOutlet weak var ordersCount: UILabel!
    @IBOutlet weak var ordersWrapView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ordersWrapView.layer.cornerRadius = 10;
        //ordersWrapView.layer.masksToBounds = true
        ordersWrapView.layer.borderWidth = 1
        ordersWrapView.layer.borderColor = UIColor.gray.cgColor
    }
    
}

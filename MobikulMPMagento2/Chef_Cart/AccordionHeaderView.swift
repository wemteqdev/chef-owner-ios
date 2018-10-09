//
//  AccordionHeaderView.swift
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 10/5/15.
//  Copyright © 2015 Fuzz. All rights reserved.
//

import UIKit
import FZAccordionTableView

class AccordionHeaderView: FZAccordionTableViewHeaderView {
    static let kDefaultAccordionHeaderViewHeight: CGFloat = 80.0;
    static let kAccordionHeaderViewReuseIdentifier = "AccordionHeaderViewReuseIdentifier";
    @IBOutlet weak var supplierImage: UIImageView!
    @IBOutlet weak var supplierName: UIButton!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var discountProgressView: UIProgressView!
    @IBOutlet weak var moqLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()        
        
        viewAllButton.layer.cornerRadius = viewAllButton.frame.height / 2
        viewAllButton.layer.masksToBounds = true
        viewAllButton.layer.borderWidth = 1
        viewAllButton.layer.borderColor = UIColor().HexToColor(hexString: "007AFF").cgColor
    }
}

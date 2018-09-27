//
//  FilteredTableViewCell.swift
//  MobikulRTL
//
//  Created by rakesh kumar on 24/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class FilteredTableViewCell: UITableViewCell {
// MARK: FilteredTableViewCell
    @IBOutlet weak var clearAllBtn: UIButton!
    
// MARK: filters
    @IBOutlet weak var filteredLabel: UILabel!
    
    @IBOutlet weak var redCrossBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

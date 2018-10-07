//
//  Chef_MyCartTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 29/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_MyCartTableViewCell: UITableViewCell {
    @IBOutlet weak var productNameLabelValue:UILabel!
    @IBOutlet weak var productImageView:UIImageView!
    @IBOutlet weak var subtotalLabelValue:UILabel!
    @IBOutlet weak var priceLabelValue:UILabel!
    @IBOutlet weak var qtyValue:UIButton!
    @IBOutlet weak var minusButton:UIButton!
    @IBOutlet weak var plusButton:UIButton!
    @IBOutlet weak var errorMessage:UILabel!
    var myCartViewModel:Chef_MyCartViewModel!
    var myCartView:UITableView!
    var kilos:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func plusClick(_ sender: UIButton) {
        kilos = Int(qtyValue.title(for: .normal)!)! + 1
        if kilos < 0 {
            kilos = 0
        }
        qtyValue.setTitle(String(kilos), for: .normal)
        myCartViewModel.setQtyDataToCartModel(data: String(kilos), pos: sender.tag)
        myCartView.reloadData()
    }
    @IBAction func minusClick(_ sender: UIButton) {
        kilos = Int(qtyValue.title(for: .normal)!)! - 1
        if kilos < 0 {
            kilos = 0
        }
        qtyValue.setTitle(String(kilos), for: .normal)
        myCartViewModel.setQtyDataToCartModel(data: String(kilos), pos: sender.tag)
        print(sender.tag)
        print(kilos)
        myCartView.reloadData()
    }
}

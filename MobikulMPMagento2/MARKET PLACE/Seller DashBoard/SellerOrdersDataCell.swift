//
//  SellerOrdersDataCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerOrdersDataCell: UITableViewCell {
@IBOutlet weak var orderLabel: UILabel!
@IBOutlet weak var orderLabelValue: UILabel!
@IBOutlet weak var customerNameLabel: UILabel!
@IBOutlet weak var customerNameValue: UILabel!
@IBOutlet weak var statusMessage: UILabel!
@IBOutlet weak var orderDateLabel: UILabel!
@IBOutlet weak var orderDateValue: UILabel!
@IBOutlet weak var orderTotalBaseLabel: UILabel!
@IBOutlet weak var orderTotalBaseLabelValue: UILabel!
@IBOutlet weak var orderTotalPurchaseLabel: UILabel!
@IBOutlet weak var orderTotalPurchaseValue: UILabel!
@IBOutlet weak var itemNameLabel: UILabel!
@IBOutlet weak var productCollectionView: UICollectionView!
@IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
var sellerProducts = [SellerProducts]()
var delegate: sellerProductHandlerDelegate!
@IBOutlet weak var seeDetailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderLabel.text = GlobalData.sharedInstance.language(key: "orderid")
        customerNameLabel.text = GlobalData.sharedInstance.language(key: "customername")
        orderDateLabel.text = GlobalData.sharedInstance.language(key: "orderplaced")
        orderTotalBaseLabel.text = GlobalData.sharedInstance.language(key: "ordertotalbase")
        orderTotalPurchaseLabel.text = GlobalData.sharedInstance.language(key: "ordertotalpurchased")
        itemNameLabel.text = GlobalData.sharedInstance.language(key: "itemname")
        
        orderLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        customerNameLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        orderDateLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        orderTotalBaseLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        orderTotalPurchaseLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        itemNameLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
        
        
        productCollectionViewHeight.constant = 5
        productCollectionView.register(UINib(nibName: "ProductNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductNameCollectionViewCell")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}






extension SellerOrdersDataCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return sellerProducts.count
     }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductNameCollectionViewCell", for: indexPath) as! ProductNameCollectionViewCell
        cell.productName.text = sellerProducts[indexPath.row].name
        cell.productCount.text = sellerProducts[indexPath.row].qty
        self.productCollectionViewHeight.constant = self.productCollectionView.contentSize.height
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 16 , height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.productClick(name:sellerProducts[indexPath.row].name , id: sellerProducts[indexPath.row].productId)
    
    }
    
    
    
    
    
}








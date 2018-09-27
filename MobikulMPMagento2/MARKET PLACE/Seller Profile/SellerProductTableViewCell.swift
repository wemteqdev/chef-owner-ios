//
//  SellerProductTableViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 06/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit


@objc protocol sellerProductViewControllerHandlerDelegate: class {
    func productClick(name:String,image:String,id:String)
    func addToWishList(productID:String)
    func addToCompare(productID:String)
    
}




class SellerProductTableViewCell: UITableViewCell {
    @IBOutlet weak var sellerCollectionLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var sellerproducts = [SellerRecentProduct]()
    var delegate:sellerProductViewControllerHandlerDelegate!
    @IBOutlet weak var viewAllButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewHeight.constant = 20
        productCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        viewAllButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        viewAllButton.setTitle(GlobalData.sharedInstance.language(key: "viewall"), for: .normal)
        sellerCollectionLabel.text = GlobalData.sharedInstance.language(key: "sellerCollection")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension SellerProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sellerproducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        cell.layer.cornerRadius = 8
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:sellerproducts[indexPath.row].productImage , imageView: cell.productImage)
        cell.productName.text = sellerproducts[indexPath.row].productName
        cell.productPrice.text = sellerproducts[indexPath.row].price
        
        
        
        cell.wishListButton.tag = indexPath.row
        cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
        cell.wishListButton.isUserInteractionEnabled = true;
        
        cell.addToCompareButton.tag = indexPath.row
        cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
        cell.addToCompareButton.isUserInteractionEnabled = true;
        
        
        
        if sellerproducts[indexPath.row].isInWishlist{
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            
        }else{
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
        }
        
        if sellerproducts[indexPath.row].isInRange == true{
            if sellerproducts[indexPath.row].specialPrice < sellerproducts[indexPath.row].normalprice{
                cell.productPrice.text = sellerproducts[indexPath.row].formatedSpecialPrice
                let attributeString = NSMutableAttributedString(string: ( sellerproducts[indexPath.row].formatedPrice ))
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                cell.specialPrice.attributedText = attributeString
                cell.specialPrice.isHidden = false;
            }
            
        }else{
            cell.specialPrice.isHidden = true;
        }
        
        
        
        self.collectionViewHeight.constant = self.productCollectionView.contentSize.height
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.productClick(name: sellerproducts[indexPath.row].productName, image: sellerproducts[indexPath.row].productImage, id: sellerproducts[indexPath.row].id)
    }
    @objc func addToWishList(sender: UIButton){
        delegate.addToWishList(productID: sellerproducts[sender.tag].id)
    }
    
    @objc func addToCompare(sender: UIButton){
        delegate.addToCompare(productID:sellerproducts[sender.tag].id)
    }
    
    
    
}

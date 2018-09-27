//
//  RecentViewTableViewCell.swift
//  MobikulMagento-2
//
//  Created by himanshu on 15/05/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

@objc protocol RecentProductViewControllerHandlerDelegate: class {
    func recentProductClick(name:String,image:String,id:String)
    func recentAddToWishList(productID:String)
    func recentAddToCompare(productID:String)
    func recentViewAllClick()
}

class RecentViewTableViewCell: UITableViewCell {

    @IBOutlet weak var recentViewLabel: UILabel!
    @IBOutlet weak var recentViewCollectionView: UICollectionView!
    
    var recentCollectionModel = [Productcollection]()
    var delegate:RecentProductViewControllerHandlerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recentViewCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        
        recentViewCollectionView.delegate = self
        recentViewCollectionView.dataSource = self
        
        recentViewLabel.text = GlobalData.sharedInstance.language(key: "RecentViews")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension RecentViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        
        cell.layer.cornerRadius = 8
        
        if indexPath.row < recentCollectionModel.count{
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:recentCollectionModel[indexPath.row].image , imageView: cell.productImage)
            cell.productName.text = recentCollectionModel[indexPath.row].name
            cell.productPrice.text = recentCollectionModel[indexPath.row].formatedPrice
            cell.layoutIfNeeded()
            
            cell.wishListButton.isHidden = false
            cell.addToCompareButton.isHidden = false
            
            cell.wishListButton.isHidden = true
            cell.wishListButton.tag = indexPath.row
            cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true;
            
            cell.addToCompareButton.tag = indexPath.row
            cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.addToCompareButton.isUserInteractionEnabled = true;
            
            if Bool(recentCollectionModel[indexPath.row].isInWishlist)!{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)

            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            if Bool(recentCollectionModel[indexPath.row].isInRange) == true{
                if recentCollectionModel[indexPath.row].specialPrice < recentCollectionModel[indexPath.row].originalPrice{
                    cell.productPrice.text = recentCollectionModel[indexPath.row].showSpecialPrice
                    let attributeString = NSMutableAttributedString(string: ( recentCollectionModel[indexPath.row].formatedPrice ))
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                    cell.specialPrice.attributedText = attributeString
                    cell.specialPrice.isHidden = false;
                }else{
                    cell.specialPrice.text = ""
                    cell.specialPrice.isHidden = true
                }
            }else{
                cell.specialPrice.text = ""
                cell.specialPrice.isHidden = true
            }
         }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < recentCollectionModel.count{
            delegate.recentProductClick(name: recentCollectionModel[indexPath.row].name, image: recentCollectionModel[indexPath.row].image, id: recentCollectionModel[indexPath.row].ProductID)
        }
    }
    
    @objc func addToCompare(sender: UIButton){
        delegate.recentAddToCompare(productID:recentCollectionModel[sender.tag].ProductID)
    }
    
    @objc func addToWishList(sender: UIButton){
        delegate.recentAddToWishList(productID:recentCollectionModel[sender.tag].ProductID)
    }
}


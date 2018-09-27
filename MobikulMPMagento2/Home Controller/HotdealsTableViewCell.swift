//
//  HotdealsTableViewCell.swift
//  Magento2V4Theme
//
//  Created by kunal on 09/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//



@objc protocol hotDealProductViewControllerHandlerDelegate: class {
    func hotDealProductClick(name:String,image:String,id:String)
    func hotDealAddToWishList(productID:String)
    func hotDealAddToCompare(productID:String)
    func hotDealViewAllClick()
}






import UIKit

class HotdealsTableViewCell: UITableViewCell {
@IBOutlet weak var hotdealLabel: UILabel!
@IBOutlet weak var hotdelalCollectionView: UICollectionView!
var hotdealCollectionModel = [Products]()
var delegate:hotDealProductViewControllerHandlerDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotdelalCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
         hotdelalCollectionView.register(UINib(nibName: "ViewAllCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllCell")
        hotdelalCollectionView.delegate = self
        hotdelalCollectionView.dataSource = self
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


extension HotdealsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return hotdealCollectionModel.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        let extracell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell
        cell.layer.cornerRadius = 8
        
        if indexPath.row < hotdealCollectionModel.count{
        
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:hotdealCollectionModel[indexPath.row].image , imageView: cell.productImage)
        cell.productName.text = hotdealCollectionModel[indexPath.row].name
        cell.productPrice.text = hotdealCollectionModel[indexPath.row].price
        cell.layoutIfNeeded()
            
        cell.wishListButton.isHidden = false
        
        cell.wishListButton.tag = indexPath.row
        cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
        cell.wishListButton.isUserInteractionEnabled = true;
        
        cell.addToCompareButton.tag = indexPath.row
        cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
        cell.addToCompareButton.isUserInteractionEnabled = true;
        
        if hotdealCollectionModel[indexPath.row].isInWishList{
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            
        }else{
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
        }
        
        if hotdealCollectionModel[indexPath.row].isInRange == 1{
            if hotdealCollectionModel[indexPath.row].specialPrice < hotdealCollectionModel[indexPath.row].originalPrice{
                cell.productPrice.text = hotdealCollectionModel[indexPath.row].showSpecialPrice
                let attributeString = NSMutableAttributedString(string: ( hotdealCollectionModel[indexPath.row].formatedPrice ))
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                cell.specialPrice.attributedText = attributeString
                cell.specialPrice.isHidden = false;
            }
        }
        return cell
        }else{
            extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
            extracell.layer.cornerRadius = 8
            return extracell
        }
        
    }

  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.row < hotdealCollectionModel.count{
                delegate.hotDealProductClick(name: hotdealCollectionModel[indexPath.row].name, image: hotdealCollectionModel[indexPath.row].image, id: hotdealCollectionModel[indexPath.row].productID)
            }else{
                delegate.hotDealViewAllClick()
            }
    }
    
    
    @objc func addToCompare(sender: UIButton){
        delegate.hotDealAddToCompare(productID:hotdealCollectionModel[sender.tag].productID )
    }
    
    @objc func addToWishList(sender: UIButton){
     delegate.hotDealAddToWishList(productID:hotdealCollectionModel[sender.tag].productID )
    let customerId = defaults.object(forKey:"customerId");
    if customerId != nil{
        sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
    }
    }
    
    
    
}


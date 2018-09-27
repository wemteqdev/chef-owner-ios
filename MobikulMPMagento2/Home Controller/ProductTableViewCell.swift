//
//  ProductTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul on 04/11/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

@objc protocol productViewControllerHandlerDelegate: class {
    func productClick(name:String,image:String,id:String)
    func newAndFeartureAddToWishList(productID:String)
    func newAndFeartureAddToCompare(productID:String)
    func viewAllClick(type:String)
}



class ProductTableViewCell: UITableViewCell {
    
    var productCollectionModel = [Products]()
    var featuredProductCollectionModel = [Products]()
    
    var titles:String = ""
    var delegate:productViewControllerHandlerDelegate!
    var homeViewModel : HomeViewModel!
    @IBOutlet weak var prodcutCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newProductButton: UIButton!
    @IBOutlet weak var newProductLabel: UILabel!
    @IBOutlet weak var featureProductLabel: UILabel!
    @IBOutlet weak var featureProductButton: UIButton!
    var showFeature:Bool = true
    var whichApiToProcess:String = ""
    var productID:String = ""
    var homeViewController:ViewController!
    
    var modelTag:Int = 0
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showFeature = true
        productCollectionViewHeight.constant = 20
        prodcutCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        prodcutCollectionView.register(UINib(nibName: "ViewAllCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllCell")
        prodcutCollectionView.delegate = self
        prodcutCollectionView.dataSource = self
        newProductLabel.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        newProductButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        featureProductLabel.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        featureProductButton.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY), for: .normal)
        
        newProductButton.setTitle(GlobalData.sharedInstance.language(key: "featureproduct"), for: .normal)
        featureProductButton.setTitle(GlobalData.sharedInstance.language(key: "newproduct"), for: .normal)
        prodcutCollectionView.reloadData()
        
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
    
    
    
    @IBAction func NewProductClick(_ sender: UIButton) {
        newProductLabel.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        newProductButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        featureProductLabel.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        featureProductButton.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY), for: .normal)
        showFeature = true
        prodcutCollectionView.reloadData()
        GlobalVariables.hometableView.reloadDataWithAutoSizingCellWorkAround()
    }
    
    
    
    @IBAction func FeatureButtonClick(_ sender: UIButton) {
        newProductLabel.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        newProductButton.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY), for: .normal)
        featureProductLabel.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        featureProductButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        showFeature = false;
        self.prodcutCollectionView.reloadData()
        GlobalVariables.hometableView.reloadDataWithAutoSizingCellWorkAround()
        
    }
    
}


extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showFeature == true{
            if featuredProductCollectionModel.count > 0{
                collectionView.backgroundView = nil
                return featuredProductCollectionModel.count + 1
            }else{
                let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                messageLabel.text = GlobalData.sharedInstance.language(key: "noproductsavailble")
                messageLabel.textColor = UIColor.black
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: REGULARFONT, size: 15)
                messageLabel.sizeToFit()
                collectionView.backgroundView = messageLabel;
                self.productCollectionViewHeight.constant = 100
                return 0
                
            }
        }else{
            if productCollectionModel.count > 0{
                collectionView.backgroundView = nil
                return productCollectionModel.count + 1
            }else{
                let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                messageLabel.text = GlobalData.sharedInstance.language(key: "noproductsavailble")
                messageLabel.textColor = UIColor.black
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: REGULARFONT, size: 15)
                messageLabel.sizeToFit()
                collectionView.backgroundView = messageLabel;
                self.productCollectionViewHeight.constant = 100
                return 0
                
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        let extracell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell
        
        cell.productImage.image = UIImage(named: "ic_placeholder.png")
        cell.layer.cornerRadius = 8
        if showFeature == true{
            if indexPath.row < featuredProductCollectionModel.count{
                
                cell.wishListButton.isHidden = false
                
                GlobalData.sharedInstance.getImageFromUrl(imageUrl:featuredProductCollectionModel[indexPath.row].image , imageView: cell.productImage)
                cell.productName.text = featuredProductCollectionModel[indexPath.row].name
                cell.productPrice.text = featuredProductCollectionModel[indexPath.row].price
                cell.layoutIfNeeded()
                
                self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                cell.wishListButton.tag = indexPath.row
                cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
                cell.wishListButton.isUserInteractionEnabled = true;
                
                cell.addToCompareButton.tag = indexPath.row
                cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
                cell.addToCompareButton.isUserInteractionEnabled = true;
                
                
                
                if featuredProductCollectionModel[indexPath.row].isInWishList{
                    cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    
                }else{
                    cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                }
                
                
                if featuredProductCollectionModel[indexPath.row].typeID == "grouped"{
                    cell.productPrice.text =  featuredProductCollectionModel[indexPath.row].groupedPrice
                }
                else if featuredProductCollectionModel[indexPath.row].typeID == "bundle"{
                    cell.productPrice.text =  featuredProductCollectionModel[indexPath.row].formatedMinPrice
                    
                }
                else{
                    if featuredProductCollectionModel[indexPath.row].isInRange == 1{
                        if featuredProductCollectionModel[indexPath.row].specialPrice < featuredProductCollectionModel[indexPath.row].originalPrice{
                            cell.productPrice.text = featuredProductCollectionModel[indexPath.row].showSpecialPrice
                            let attributeString = NSMutableAttributedString(string: ( featuredProductCollectionModel[indexPath.row].formatedPrice ))
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                            cell.specialPrice.attributedText = attributeString
                            cell.specialPrice.isHidden = false;
                        }
                        
                    }else{
                        cell.specialPrice.isHidden = true;
                    }
                    
                }
                cell.layoutIfNeeded()
                self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                
                return cell;
                
            }else{
                cell.layoutIfNeeded()
                self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
                extracell.layer.cornerRadius = 8
                return extracell
            }
            
        }
        else{
            if indexPath.row < productCollectionModel.count{
                cell.wishListButton.isHidden = false
                GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionModel[indexPath.row].image , imageView: cell.productImage)
                cell.productName.text = productCollectionModel[indexPath.row].name
                cell.productPrice.text = productCollectionModel[indexPath.row].price
                
                cell.wishListButton.tag = indexPath.row
                cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
                cell.wishListButton.isUserInteractionEnabled = true;
                
                cell.addToCompareButton.tag = indexPath.row
                cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
                cell.addToCompareButton.isUserInteractionEnabled = true;
                
                if productCollectionModel[indexPath.row].isInWishList{
                    cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    
                }else{
                    cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                }
                
                if productCollectionModel[indexPath.row].typeID == "grouped"{
                    cell.productPrice.text =  productCollectionModel[indexPath.row].groupedPrice
                }
                else if productCollectionModel[indexPath.row].typeID == "bundle"{
                    cell.productPrice.text =  productCollectionModel[indexPath.row].formatedMinPrice
                    
                }
                else{
                    if productCollectionModel[indexPath.row].isInRange == 1{
                        if productCollectionModel[indexPath.row].specialPrice < productCollectionModel[indexPath.row].originalPrice{
                            cell.productPrice.text = productCollectionModel[indexPath.row].showSpecialPrice
                            let attributeString = NSMutableAttributedString(string: ( productCollectionModel[indexPath.row].formatedPrice ))
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                            cell.specialPrice.attributedText = attributeString
                            cell.specialPrice.isHidden = false;
                        }
                        
                    }else{
                        cell.specialPrice.isHidden = true;
                    }
                    
                }
                cell.layoutIfNeeded()
                self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                return cell
            }else{
                extracell.layoutIfNeeded()
                self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
                extracell.layer.cornerRadius = 8
                return extracell
            }
            
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showFeature == true{
            if indexPath.row < featuredProductCollectionModel.count{
                delegate.productClick(name: featuredProductCollectionModel[indexPath.row].name, image: featuredProductCollectionModel[indexPath.row].image, id: featuredProductCollectionModel[indexPath.row].productID)
            }else{
                delegate.viewAllClick(type: "feature")
            }
        }else{
            if indexPath.row < productCollectionModel.count{
                delegate.productClick(name: productCollectionModel[indexPath.row].name, image: productCollectionModel[indexPath.row].image, id: productCollectionModel[indexPath.row].productID)
            }else{
                delegate.viewAllClick(type: "new")
            }
        }
    }
    
    @objc func addToWishList(sender: UIButton){
        
        modelTag = sender.tag
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            if showFeature == true{
                let wishListFlag = featuredProductCollectionModel[sender.tag].isInWishList
                
                if !wishListFlag!{
                    productID = featuredProductCollectionModel[sender.tag].productID
                    sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    whichApiToProcess = "addtowishlist"
                    self.callingExtraHttpApi()
                }else{
                    productID = featuredProductCollectionModel[sender.tag].wishlistItemId
                    sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                    whichApiToProcess = "removewishlist"
                    self.callingExtraHttpApi()
                }
            }else{
                let wishListFlag = productCollectionModel[sender.tag].isInWishList
                
                if !wishListFlag!{
                    productID = productCollectionModel[sender.tag].productID
                    sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    whichApiToProcess = "addtowishlist"
                    self.callingExtraHttpApi()
                    
                }else{
                    productID = productCollectionModel[sender.tag].wishlistItemId
                    sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                    whichApiToProcess = "removewishlist"
                    self.callingExtraHttpApi()
                }
            }
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }
    }
    
    @objc func addToCompare(sender: UIButton){
        if showFeature == true{
            delegate.newAndFeartureAddToCompare(productID: featuredProductCollectionModel[sender.tag].productID)
        }else{
            delegate.newAndFeartureAddToCompare(productID: productCollectionModel[sender.tag].productID)
        }
    }
    
    func callingExtraHttpApi(){
        homeViewController.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "addtowishlist"{
            requstParams["productId"] = productID
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtoWishlist", currentView: homeViewController){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.homeViewController.view.isUserInteractionEnabled = true
                    let data = JSON(responseObject as! NSDictionary)
                    
                    if data["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlist"))
                        if self.showFeature == true{
                            self.featuredProductCollectionModel[self.modelTag].isInWishList = true;
                            self.featuredProductCollectionModel[self.modelTag].wishlistItemId = data["itemId"].stringValue;
                            self.homeViewModel.setWishListFlagToFeaturedProductModel(data: true, pos: self.modelTag)
                            self.homeViewModel.setWishListItemIdToFeaturedProductModel(data:data["itemId"].stringValue , pos: self.modelTag)
                        }else{
                            self.productCollectionModel[self.modelTag].isInWishList = true;
                            self.productCollectionModel[self.modelTag].wishlistItemId = data["itemId"].stringValue;
                            self.homeViewModel.setWishListFlagToLatestProductModel(data: true, pos: self.modelTag)
                            self.homeViewModel.setWishListItemIdToLatestProductModel(data:data["itemId"].stringValue , pos: self.modelTag)
                        }
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }else if whichApiToProcess == "removewishlist"{
            
            GlobalData.sharedInstance.showLoader()
            
            var requstParams = [String:Any]();
            
            requstParams["itemId"] = productID
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/removefromWishlist", currentView: homeViewController){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.homeViewController.view.isUserInteractionEnabled = true
                    
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        if self.showFeature == true{
                            self.featuredProductCollectionModel[self.modelTag].isInWishList = false;
                            self.homeViewModel.setWishListFlagToFeaturedProductModel(data: false, pos: self.modelTag)
                        }else{
                            self.productCollectionModel[self.modelTag].isInWishList = false;
                            self.homeViewModel.setWishListFlagToLatestProductModel(data: false, pos: self.modelTag)
                        }
                    }
                }else if success == 2{
                    self.callingExtraHttpApi();
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
    }
}

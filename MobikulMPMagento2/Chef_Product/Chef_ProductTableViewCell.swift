//
//  Chef_ProductTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 16/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
@objc protocol chef_productViewControllerHandlerDelegate: class {
    func productClick(name:String,image:String,id:String,supplierName:String,addShow:Bool)
    func newAndFeartureAddToWishList(productID:String)
    func newAndFeartureAddToCompare(productID:String)
    func viewAllClick(type:String)
}

class Chef_ProductTableViewCell: UITableViewCell {
    var productCollectionModel = [Products]()
    var featuredProductCollectionModel = [Products]()
    
    var titles:String = ""
    var delegate:chef_productViewControllerHandlerDelegate!
    var homeViewModel : Chef_HomeViewModel!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var prodcutCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productCollectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var newProductButton: UIButton!
    @IBOutlet weak var newProductLabel: UILabel!
    @IBOutlet weak var ProductLabel: UILabel!
    @IBOutlet weak var featureProductButton: UIButton!
    var showFeature:Bool = true
    
    @IBOutlet weak var viewMoreBtn: UIButton!
    var whichApiToProcess:String = ""
    var productID:String = ""
    var homeViewController:Chef_ProductViewController!
    
    var modelTag:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        productCollectionViewHeight.constant = 20
        prodcutCollectionView.register(UINib(nibName: "Chef_ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "chef_productimagecell")
        //prodcutCollectionView.register(UINib(nibName: "ViewAllCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
 
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        prodcutCollectionView!.collectionViewLayout = layout
        prodcutCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
       
        prodcutCollectionView.delegate = self
        prodcutCollectionView.dataSource = self
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
        //ProductLabel.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        featureProductButton.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY), for: .normal)
        showFeature = true
        prodcutCollectionView.reloadData()
        GlobalVariables.hometableView.reloadDataWithAutoSizingCellWorkAround()
    }
    @IBAction func viewMoreClick(_ sender: UIButton) {
        delegate.viewAllClick(type: "feature")
    }
    
    
    @IBAction func FeatureButtonClick(_ sender: UIButton) {
        newProductLabel.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        newProductButton.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY), for: .normal)
        ProductLabel.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        featureProductButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        showFeature = false;
        self.prodcutCollectionView.reloadData()
        GlobalVariables.hometableView.reloadDataWithAutoSizingCellWorkAround()
        
    }
    
}
extension Chef_ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        if showFeature == true{
            if featuredProductCollectionModel.count > 0{
                collectionView.backgroundView = nil
                return featuredProductCollectionModel.count
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
                return productCollectionModel.count
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


        //let extracell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell
        
        
        if showFeature == true{
            if indexPath.row < featuredProductCollectionModel.count{
                if(homeViewController.change == true){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_productimagecell", for: indexPath) as! Chef_ProductImageCell
                    
                    cell.productImage.image = UIImage(named: "product_image")
                    cell.alonePrice.isHidden = true
                    cell.wishListButton.isHidden = true
                    cell.reviewCnt.text =  "\(String(featuredProductCollectionModel[indexPath.row].reviewCount)) reviews"
                    cell.starRating.value = CGFloat(featuredProductCollectionModel[indexPath.row].rating)
                    cell.ratingbtn.setTitle(String(featuredProductCollectionModel[indexPath.row].rating), for: .normal)
                    cell.price_vat.text = "\(String(featuredProductCollectionModel[indexPath.row].price))\(String(featuredProductCollectionModel[indexPath.row].unit)) - \(String(featuredProductCollectionModel[indexPath.row].taxClass))"
                    cell.supplierName.text =  featuredProductCollectionModel[indexPath.row].supplierName
                    print(featuredProductCollectionModel[indexPath.row].productID)
                    print("CATEGORIES FOR THIS ID")
//                    if self.homeViewModel.productcategory[featuredProductCollectionModel[indexPath.row].productID].contains(self.homeViewController.categoryId) {
//
//                    }
                    print(self.homeViewController.categoryId)
                    print(self.homeViewModel.productcategory[featuredProductCollectionModel[indexPath.row].productID].object as? [String])
//                    if (self.homeViewController.categoryId != "") {
//                        if let haystack = self.homeViewModel.productcategory[featuredProductCollectionModel[indexPath.row].productID].object as? [String] {
//                            let needle = self.homeViewController.categoryId
//                            if haystack.contains(needle) {
//                                print("DEDICATED CATEGORY")
//                            }
//                            else {
//                                print("NOT DEDICATED CATEGORY")
//                                cell.isHidden = true
//                                return cell
//                            }
//                        }
//                    }
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl:featuredProductCollectionModel[indexPath.row].image , imageView: cell.productImage)
                    cell.productName.text = featuredProductCollectionModel[indexPath.row].name
                    cell.productPrice.text = featuredProductCollectionModel[indexPath.row].price
                    cell.alonePrice.text = featuredProductCollectionModel[indexPath.row].price
                
                    self.productCollectionViewHeight.constant = cell.frame.height
                     self.productCollectionViewWidth.constant = prodcutCollectionView.contentSize.width
                   cell.addButton.tag = indexPath.row
                    cell.addButton.addTarget(self, action: #selector(addButtonClick(sender:)), for: .touchUpInside)
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
                        //if featuredProductCollectionModel[indexPath.row].isInRange == 1{
                            if featuredProductCollectionModel[indexPath.row].tierPrice < featuredProductCollectionModel[indexPath.row].originalPrice && featuredProductCollectionModel[indexPath.row].tierPrice != 0{
                                cell.specialPrice.text = "\(featuredProductCollectionModel[indexPath.row].formatedPrice.prefix(1))\(String(featuredProductCollectionModel[indexPath.row].tierPrice))"
                                
                                let attributedString = NSMutableAttributedString(string:( featuredProductCollectionModel[indexPath.row].formatedPrice ))
                                attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
                                attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.styleThick.rawValue), range: NSMakeRange(0, attributedString.length))
                                attributedString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
                                
                                cell.productPrice.attributedText = attributedString
                                cell.specialPrice.isHidden = false;
                            //}
                            
                        }else{
                            cell.specialPrice.isHidden = true
                            cell.productPrice.isHidden = true
                            cell.alonePrice.isHidden = false
                        }
                        
                    }
                    cell.layoutIfNeeded()
                    //self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                    if featuredProductCollectionModel[indexPath.row].nonEditable == true {
                        cell.addButton.isUserInteractionEnabled = false
                        cell.addToCompareButton.isUserInteractionEnabled = false
                        
                        cell.addButton.setTitleColor(UIColor.gray, for: .normal)
                        cell.addButton.backgroundColor = UIColor.lightGray
                        cell.addToCompareButton.setTitleColor(UIColor.gray, for: .normal)
                        cell.addToCompareButton.backgroundColor = UIColor.lightGray
                    }
                    else {
                        cell.addButton.isUserInteractionEnabled = true
                        cell.addToCompareButton.isUserInteractionEnabled = true
                        
                        cell.addButton.setTitleColor(UIColor.white, for: .normal)
                        cell.addButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
                        cell.addToCompareButton.setTitleColor(UIColor.gray, for: .normal)
                        cell.addToCompareButton.backgroundColor = UIColor.white
                        
                    }
                    return cell;
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_listcollectionview", for: indexPath) as! Chef_ListCollectionViewCell
                    
                    cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
                    cell.layer.borderWidth = 0.5

                    //cell.imageView.image = UIImage(named: "ic_placeholder.png")
                    cell.name.text = featuredProductCollectionModel[indexPath.row].name
                    cell.price.text =  featuredProductCollectionModel[indexPath.row].price
                    self.productCollectionViewHeight.constant = cell.frame.height
                    
                    cell.reviewCnt.text =  "\(String(featuredProductCollectionModel[indexPath.row].reviewCount)) reviews"
                    cell.starRating.value = CGFloat(featuredProductCollectionModel[indexPath.row].rating)
                    cell.ratingbtn.setTitle(String(featuredProductCollectionModel[indexPath.row].rating), for: .normal)
                    cell.pricevat.text = "\(String(featuredProductCollectionModel[indexPath.row].price))\(String(featuredProductCollectionModel[indexPath.row].unit)) - \(String(featuredProductCollectionModel[indexPath.row].taxClass))"
                    cell.supplierName.text =  featuredProductCollectionModel[indexPath.row].supplierName
                    //cell.descriptionData.text = featuredPrproduoductCollectionModel[indexPath.row].descriptionData
                   
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl:featuredProductCollectionModel[indexPath.row].image , imageView: cell.imageView)
                    cell.wishList_Button.tag = indexPath.row
                    cell.compare_Button.tag = indexPath.row
                    cell.compare_Button.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
                    
                    cell.addButton.tag = indexPath.row
                    cell.addButton.addTarget(self, action: #selector(addButtonClick(sender:)), for: .touchUpInside)
                    cell.specialPrice.isHidden = true
                    self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                    
                    if featuredProductCollectionModel[indexPath.row].isInWishList{
                        cell.wishList_Button.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    }else{
                        cell.wishList_Button.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                    }
                    
                    cell.wishList_Button.tag = indexPath.row
                    cell.wishList_Button.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
                    cell.wishList_Button.isUserInteractionEnabled = true
                    
                    cell.compare_Button.tag = indexPath.row
                    cell.compare_Button.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
                    cell.compare_Button.isUserInteractionEnabled = true
                    
                    //if featuredProductCollectionModel[indexPath.row].isInRange == 1{
                        if featuredProductCollectionModel[indexPath.row].tierPrice < featuredProductCollectionModel[indexPath.row].originalPrice && featuredProductCollectionModel[indexPath.row].tierPrice != 0{
                            cell.specialPrice.text = "\(featuredProductCollectionModel[indexPath.row].formatedPrice.prefix(1))\(String(featuredProductCollectionModel[indexPath.row].tierPrice))"
                            let attributeString = NSMutableAttributedString(string: featuredProductCollectionModel[indexPath.row].formatedPrice)
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                            cell.price.attributedText = attributeString
                            cell.specialPrice.isHidden = false
                        }else{
                            cell.price.text =  featuredProductCollectionModel[indexPath.row].price
                            cell.specialPrice.isHidden = true
                            
                        }
                    if featuredProductCollectionModel[indexPath.row].nonEditable == true {
                        cell.addButton.isUserInteractionEnabled = false
                        cell.compare_Button.isUserInteractionEnabled = false
                        
                        cell.addButton.setTitleColor(UIColor.gray, for: .normal)
                        cell.addButton.backgroundColor = UIColor.lightGray
                        cell.compare_Button.setTitleColor(UIColor.gray, for: .normal)
                        cell.compare_Button.backgroundColor = UIColor.lightGray
                    }
                    else {
                        cell.addButton.isUserInteractionEnabled = true
                        cell.compare_Button.isUserInteractionEnabled = true
                        
                        cell.addButton.setTitleColor(UIColor.white, for: .normal)
                        cell.addButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
                        cell.compare_Button.setTitleColor(UIColor.gray, for: .normal)
                        cell.compare_Button.backgroundColor = UIColor.white
                        
                    }
                    //}
                    cell.layoutIfNeeded()
                    return cell
                }

                
            //}else{
                //cell.layoutIfNeeded()
                //self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                /*extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
                extracell.layer.cornerRadius = 8
                return extracell*/
            }
            
        }
        else{
            if indexPath.row < productCollectionModel.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_productimagecell", for: indexPath) as! Chef_ProductImageCell
                cell.wishListButton.isHidden = true
                GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionModel[indexPath.row].image , imageView: cell.productImage)
                cell.productName.text = productCollectionModel[indexPath.row].name
                cell.productPrice.text = productCollectionModel[indexPath.row].price
                
                cell.reviewCnt.text =  "\(String(featuredProductCollectionModel[indexPath.row].reviewCount)) reviews"
                cell.starRating.value = CGFloat(featuredProductCollectionModel[indexPath.row].rating)
                cell.ratingbtn.setTitle(String(featuredProductCollectionModel[indexPath.row].rating), for: .normal)
                cell.price_vat.text = "\(String(featuredProductCollectionModel[indexPath.row].price)) - \(String(featuredProductCollectionModel[indexPath.row].taxClass))"
                cell.supplierName.text =  featuredProductCollectionModel[indexPath.row].supplierName
                
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
                //self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                return cell
            }
           // }else{
                /*extracell.layoutIfNeeded()
                //self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
                extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
                extracell.layer.cornerRadius = 8
                return extracell*/
               // return cell;
            //}
        
            
        }
       return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if homeViewController.change == false{
            return CGSize(width: collectionView.frame.size.width, height: 414/2 - 80 )
        }else{
            return CGSize(width: 414/3 + 30 , height: 414/2 + 100 )
            //return CGSize(width: collectionView.frame.size.width/2, height:SCREEN_WIDTH/2.5 + 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showFeature == true{
            delegate.productClick(name: featuredProductCollectionModel[indexPath.row].name, image: featuredProductCollectionModel[indexPath.row].image, id: featuredProductCollectionModel[indexPath.row].productID,supplierName: featuredProductCollectionModel[indexPath.row].supplierName, addShow: featuredProductCollectionModel[indexPath.row].nonEditable)
            
        }else{
            
                //delegate.productClick(name: productCollectionModel[indexPath.row].name, image: productCollectionModel[indexPath.row].image, id: productCollectionModel[indexPath.row].productID)
            
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
    @objc func addButtonClick(sender: UIButton){
        if showFeature == true{
            delegate.productClick(name: featuredProductCollectionModel[sender.tag].name, image: featuredProductCollectionModel[sender.tag].image, id: featuredProductCollectionModel[sender.tag].productID, supplierName: featuredProductCollectionModel[sender.tag].supplierName,addShow: featuredProductCollectionModel[sender.tag].nonEditable )
            
           
        }else{
            //delegate.productClick(name: productCollectionModel[sender.tag].name, image: productCollectionModel[sender.tag].image, id: productCollectionModel[sender.tag].productID )
            
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

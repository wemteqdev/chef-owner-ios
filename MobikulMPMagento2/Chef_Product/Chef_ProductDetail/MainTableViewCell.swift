//
//  MainTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 14/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
@objc protocol Chef_DetailReviewHandlerDelegate: class {
    func reviewSubmit(title:String,contentText:String,rating:String)
}

class MainTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var baseDetailView: UIView!
    @IBOutlet weak var baseReviewView: UIView!
    @IBOutlet weak var baseCompareView: UIView!
    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
    var parentController: Chef_DashboardViewController!
    var currentMainView: Int = 0
    var catalogProductViewModel:CatalogProductViewModel!
    var compareProductCollectionModel = [Products]()
    var delegate:Chef_DetailReviewHandlerDelegate!
    var titleText:String = ""
    var contentText:String = ""
    var rating:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productDetailCollectionView.register(UINib(nibName: "Chef_DetailCell", bundle: nil), forCellWithReuseIdentifier: "chef_detailcell")
        productDetailCollectionView.register(UINib(nibName: "Chef_ReviewSubmitCell", bundle: nil), forCellWithReuseIdentifier: "chef_reviewsubmitcell")
        productDetailCollectionView.delegate = self
        productDetailCollectionView.dataSource = self
        productDetailCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if catalogProductViewModel != nil{
            if currentMainView == 0 {
                    return 1
            }
            else if currentMainView == 1 {
                if catalogProductViewModel.catalogProductModel.reviewList.count > 0{
                    return catalogProductViewModel.catalogProductModel.reviewList.count + 1
                }
                else{
                    return 1
                }
            }
            else {
                if compareProductCollectionModel.count > 0{
                    return compareProductCollectionModel.count
                }
                else{
                    return 0
                }
            }
        }
        else{
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("COLLECTION SIZE~~~~~~~~~~~~~")
        if currentMainView == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height )
        }
        else {
            if indexPath.row ==  catalogProductViewModel.catalogProductModel.reviewList.count
            {
                return CGSize(width: collectionView.frame.width, height: 180 )
            }
            return CGSize(width: collectionView.frame.width, height: 90 )
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CollectionVIEW~~~~~~~~~~~~~~~~~~~~")
       
        switch currentMainView {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_detailcell", for: indexPath) as! Chef_DetailCell
                cell.textview.insertText(catalogProductViewModel.catalogProductModel.descriptionData);
            print("DETAIL CELL INFO")
            var attrStr = try! NSAttributedString(
                data: catalogProductViewModel.catalogProductModel.descriptionData.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            cell.textview.attributedText = attrStr
            print(catalogProductViewModel.catalogProductModel.descriptionData)
            return cell

        case 1:
            if indexPath.row ==  catalogProductViewModel.catalogProductModel.reviewList.count
            {
                print("SUBMIT REVIEW CELL")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_reviewsubmitcell", for: indexPath) as! Chef_ReviewSubmitCell
                
                cell.submitButton.tag = indexPath.row
                cell.titleLabel.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingChanged)
                
                cell.textView.addTarget(self, action: #selector(contentDidChange(_:)), for: .editingChanged)
                
                cell.starRating.addTarget(self, action: #selector(starRatingDidChange(_:)), for: .valueChanged)
                
                cell.submitButton.addTarget(self, action: #selector(reviewSubmit(sender:)), for: .touchUpInside)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_reviewcell", for: indexPath) as! Chef_ReviewCell
            cell.reviewTitle.text = catalogProductViewModel.getReviewListData[indexPath.row].title

            let ratingArr:Array = catalogProductViewModel.getReviewListData[indexPath.row].ratingsData
            
            let ratingCount:Float = Float(catalogProductViewModel.getReviewListData[indexPath.row].ratingsData.count)
            var ratingVal:Float = 0
            
            
            for i in 0..<catalogProductViewModel.getReviewListData[indexPath.row].ratingsData.count {
                let dict = ratingArr[i]
                let val = dict["value"].floatValue
                ratingVal = ratingVal + val
                print("cccvv",ratingVal)
            }
            print(catalogProductViewModel.getReviewListData[indexPath.row].ratingsData)
            
            
            cell.reviewRating.value = CGFloat((ratingVal/ratingCount) as Float)
            
           print("REVIEWLIST CELL INFO")
            var attrStr = try! NSAttributedString(
                data: catalogProductViewModel.reviewList[indexPath.row].details.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            cell.textview.attributedText = attrStr
           print(ratingVal)
            print(catalogProductViewModel.reviewList[indexPath.row].title)
            let reviewerName:String = catalogProductViewModel.reviewList[indexPath.row].reviewBy.toLengthOf(length: 10)
            var reviewData:String = catalogProductViewModel.reviewList[indexPath.row].reviewOn.toLengthOf(length: 11)
            
            cell.reviewerandtime.text = "\(reviewerName) - \(reviewData.prefix(10))"
            print("\(reviewerName) - \(reviewData.prefix(10))")
            return cell

        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_dcomparecell", for: indexPath) as! Chef_DetailCompareCell
            
            cell.price.text = compareProductCollectionModel[indexPath.row].price
            cell.pricevat.text = "\(String(compareProductCollectionModel[indexPath.row].price)) - \(String(compareProductCollectionModel[indexPath.row].taxClass))"
            cell.reviewStar.value = CGFloat(compareProductCollectionModel[indexPath.row].rating)
            cell.reviewRatingmark.text = String(compareProductCollectionModel[indexPath.row].rating)
            cell.reviewCount.text = "\(String(compareProductCollectionModel[indexPath.row].reviewCount)) reviews"
            cell.supplierName.text = compareProductCollectionModel[indexPath.row].supplierName
            //cell.moq.text = compareProductCollectionModel[indexPath.row].minAddToCartQty
            cell.moq.text = compareProductCollectionModel[indexPath.row].price
            if compareProductCollectionModel[indexPath.row].isMin == true{
                cell.discountLayer.isHidden = false
                cell.discountLabel.isHidden = false
                cell.discountLabel.setTitle("Save \(String(compareProductCollectionModel[indexPath.row].discount))%", for: .normal)
                cell.addtocart.tag = indexPath.row
                
                if compareProductCollectionModel[indexPath.row].userStatus == true{
                    cell.addtocart.setTitle("WAITING APPROVE", for: .normal)
                }
                else{
                    
                    cell.addtocart.addTarget(self, action: #selector(signupSupplier(sender:)), for: .touchUpInside)
                    cell.addtocart.setTitle("SIGN UP SUPPLIER", for: .normal)
                }
            }
            else {
                cell.addtocart.tag = indexPath.row
                cell.addtocart.addTarget(self, action: #selector(addtoCart(sender:)), for: .touchUpInside)
            }
            return cell

        }
    }
    @objc func signupSupplier(sender: UIButton){
        print("SIGN UP SUPPLIER")
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        let customerId = defaults.object(forKey: "customerId")
        let quoteId = defaults.object(forKey: "quoteId")
        requstParams["supplierId"] = compareProductCollectionModel[sender.tag].supplierId
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if quoteId != nil{
            requstParams["quoteId"] = quoteId
        }
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }

        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/catalog/signupsupplier", currentView: parentController){success,responseObject in
            if success == 1{
                self.parentController.view.isUserInteractionEnabled = true
                //self.addToCartIndicator.stopAnimating()
                GlobalData.sharedInstance.dismissLoader()
                let data = responseObject as! NSDictionary
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                
                if data.object(forKey: "quoteId") != nil{
                    let quoteId:String = String(format: "%@", data.object(forKey: "quoteId") as! CVarArg)
                    if quoteId != "0"{
                        self.parentController.defaults.set(quoteId, forKey: "quoteId")
                    }
                }
                
                if errorCode == true{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg:data .object(forKey:"message") as! String )
                   
                }
                else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: data.object(forKey: "message") as! String)
                }
                
                print(data)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.signupSupplier(sender: sender)
            }
        }
    }
    @objc func addtoCart(sender: UIButton){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        let customerId = defaults.object(forKey: "customerId")
        let quoteId = defaults.object(forKey: "quoteId")
        requstParams["productId"] = compareProductCollectionModel[sender.tag].productID
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if quoteId != nil{
            requstParams["quoteId"] = quoteId
        }
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }
        requstParams["qty"] = 1
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/addtoCart", currentView: parentController){success,responseObject in
            if success == 1{
                self.parentController.view.isUserInteractionEnabled = true
                //self.addToCartIndicator.stopAnimating()
                GlobalData.sharedInstance.dismissLoader()
                let data = responseObject as! NSDictionary
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                
                if data.object(forKey: "quoteId") != nil{
                    let quoteId:String = String(format: "%@", data.object(forKey: "quoteId") as! CVarArg)
                    if quoteId != "0"{
                        self.parentController.defaults.set(quoteId, forKey: "quoteId")
                    }
                }
                
                if errorCode == true{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg:data .object(forKey:"message") as! String )
                    
                   
                    if badge == nil {
                        badge = "1"
                    }
                    else{
                        badge = String(Int(badge!)! + 1)
                    }
                    print("BADGE")
                    print(badge)
                }
                else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: data.object(forKey: "message") as! String)
                }
                
                
                
                print(data)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.addtoCart(sender: sender)
            }
        }
    }
    
    @objc func reviewSubmit(sender: UIButton){
        var errorMsg = "Please Fill or Set"
        var isValid = true
        if(rating == ""){
            errorMsg = "\(errorMsg) Rating"
            isValid = false
        }
        if(contentText == ""){
            errorMsg = "\(errorMsg) Review Detail"
            isValid = false
        }
        if(titleText == ""){
            errorMsg = "\(errorMsg) Review Title"
            isValid = false
        }
        if !isValid{
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMsg)
        }
        else{
            delegate.reviewSubmit(title:titleText,contentText:contentText,rating:rating)
        }
    }
    @objc func titleDidChange(_ textField: UITextField) {
        titleText = textField.text!
    }
    @objc func contentDidChange(_ textField: UITextField) {
        contentText = textField.text!
    }
    @objc func starRatingDidChange(_ starRating: HCSStarRatingView)
    {
        rating = starRating.value.description
    }
}
extension String {
    
    func toLengthOf(length:Int) -> String {
        if length <= 0 {
            return self
        } else if let to = self.index(self.startIndex, offsetBy: length, limitedBy: self.endIndex) {
            return self.substring(from: to)
            
        } else {
            return ""
        }
    }

}

//
//  MainTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by Othello on 14/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var baseDetailView: UIView!
    @IBOutlet weak var baseReviewView: UIView!
    @IBOutlet weak var baseCompareView: UIView!
    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
    var currentMainView: Int = 0
    var catalogProductViewModel:CatalogProductViewModel!
    var compareProductCollectionModel = [Products]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productDetailCollectionView.register(UINib(nibName: "Chef_DetailCell", bundle: nil), forCellWithReuseIdentifier: "chef_detailcell")
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
                    return catalogProductViewModel.catalogProductModel.reviewList.count
                }
                else{
                    return 0
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
             return CGSize(width: collectionView.frame.width, height: 120 )
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
            cell.moq.text = compareProductCollectionModel[indexPath.row].minAddToCartQty
            return cell

        }
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

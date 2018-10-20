//
//  Chef_HomeViewModel.swift
//  MobikulMPMagento2
//
//  Created by Othello on 16/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//
import Foundation
import UIKit

class Chef_HomeViewModel: NSObject {
    var items = [HomeViewModelItem]()
    var featuredProductCollectionModel = [Products]()
    var recommendedProductCollectionModel = [Products]()
    var allProductCollectionModel = [Products]()
    var letestProductCollectionModel = [Products]()
    var cateoryData:[String:AnyObject]!
    var currency :NSArray = []
    var productcategory :JSON = []
    var languageData = [Languages]()
    var homeViewController:Chef_ProductViewController!
    var guestCheckOut:Bool!
    var categoryImage = [CategoryImage]()
    var storeData = [StoreData]()
    var cmsData = [CMSdata]()
    
    func getData(data : AnyObject , recentViewData : [Productcollection] , completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: JSON(data as! NSDictionary)) else {
            return
        }
        items.removeAll()
        
        if !data.bannerCollectionModel.isEmpty {
            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: data.bannerCollectionModel)
            items.append(bannerDataCollectionItem)
        }
        
        if !data.featureCategories.isEmpty {
            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featureCategories)
            //items.append(featureCategoryCollectionItem)
        }
        
        if !data.featuredProductCollectionModel.isEmpty {
            let featureCollectionItem = HomeViewModelFeatureItem(categories: data.featuredProductCollectionModel)
            items.append(featureCollectionItem)
        }
        if !data.allProductCollectionModel.isEmpty {
            let allCollectionItem = HomeViewModelAllItem(categories: data.allProductCollectionModel)
            allProductCollectionModel = data.allProductCollectionModel;
            items.append(allCollectionItem)
        }
        if !data.recommendedProductCollectionModel.isEmpty {
            let recommendedCollectionItem = HomeViewModelRecommendedItem(categories: data.recommendedProductCollectionModel)
            items.append(recommendedCollectionItem)
        }
        
        let latestCollectionItem = HomeViewModelLatestItem(categories: data.latestProductCollectionModel)
        //items.append(latestCollectionItem)
        letestProductCollectionModel = data.latestProductCollectionModel
        
        if !recentViewData.isEmpty {
            let recentViewCollectionItem = HomeViewModelRecentViewItem(categories: recentViewData)
           // items.append(recentViewCollectionItem)
        }
        
        if !data.hotDealsProduct.isEmpty {
            let hotDealCollectionItem = HomeViewModelHotdealItem(categories: data.hotDealsProduct)
           // items.append(hotDealCollectionItem)
        }
        
        if data.currency != nil{
            self.currency = data.currency
        }
        
        if data.productcategory != nil{
            self.productcategory = data.productcategory
        }
        
        if data.cmsData != nil{
            self.cmsData = data.cmsData;
        }
        
        self.categoryImage = data.categoryImage;
        self.cateoryData = data.cateoryData;
        self.storeData = data.storeData
        completion(true)
    }
    
    func setWishListFlagToFeaturedProductModel(data:Bool,pos:Int){
        featuredProductCollectionModel[pos].isInWishList = data;
    }
    
    func setWishListItemIdToFeaturedProductModel(data:String,pos:Int){
        featuredProductCollectionModel[pos].wishlistItemId = data;
    }
    
    func setWishListFlagToLatestProductModel(data:Bool,pos:Int){
        letestProductCollectionModel[pos].isInWishList = data;
    }
    
    func setWishListItemIdToLatestProductModel(data:String,pos:Int){
        letestProductCollectionModel[pos].wishlistItemId = data;
    }
}
extension Chef_HomeViewModel : UITableViewDelegate , UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int{
        //return 3
        if homeViewController.filtered == true {
            return 1
        }
        else{
            return items.count - 1 ;
            print("items \(items.count)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:Chef_ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: Chef_ProductTableViewCell.identifier) as! Chef_ProductTableViewCell
        
        if allProductCollectionModel.count < homeViewController.limitedCount {
            cell.viewMoreBtn.isHidden = true
        }
        if homeViewController.change == true {
            cell.prodcutCollectionView.register(UINib(nibName: "Chef_ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "chef_productimagecell")
            if let layout = cell.prodcutCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            cell.prodcutCollectionView.reloadData()
        }
        else {
            cell.prodcutCollectionView.register(UINib(nibName: "Chef_ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "chef_listcollectionview")
            if let layout = cell.prodcutCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
            cell.prodcutCollectionView.reloadData()

        }

        cell.prodcutCollectionView.reloadData()
        cell.prodcutCollectionView.tag = indexPath.section + 1
        //cell.productCollectionModel = letestProductCollectionModel
       
        cell.delegate = homeViewController
        //cell.featuredProductCollectionModel = featuredProductCollectionModel
       
        var index:Int!
        if homeViewController.filtered == true {
            cell.headerView.isHidden = true;
            index = 2
        }
        else{
            cell.headerView.isHidden = false;
            index = indexPath.section + 1
        }

        let item = items[index]
        
        switch item.type {
        case .Banner: break
//            let cell:BannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as! BannerTableViewCell
//            cell.delegate = homeViewController
//            cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
//            cell.selectionStyle = .none
//            return cell;
            
        case .FeatureCategory:
            let cell:TopCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as! TopCategoryTableViewCell
            cell.featureCategoryCollectionModel = ((item as? HomeViewModelFeatureCategoriesItem)?.featureCategories)!
            cell.categoryCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell
            
        case .LatestProduct:
            break
//            let cell:Chef_ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: Chef_ProductTableViewCell.identifier) as! Chef_ProductTableViewCell
//
//            if homeViewController.change == true {
//                cell.prodcutCollectionView.register(UINib(nibName: "Chef_ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "chef_productimagecell")
//                if let layout = cell.prodcutCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                    layout.scrollDirection = .horizontal
//                }
//                print("grid passed")
//            }
//            else {
//                 cell.prodcutCollectionView.register(UINib(nibName: "Chef_ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "chef_listcollectionview")
//                if let layout = cell.prodcutCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                    layout.scrollDirection = .vertical
//                }
//                print("list passed")
//            }
//
//            cell.prodcutCollectionView.reloadData()
//            cell.prodcutCollectionView.tag = indexPath.section
//            cell.productCollectionModel = letestProductCollectionModel
//            cell.delegate = homeViewController
//            cell.featuredProductCollectionModel = featuredProductCollectionModel
//            cell.homeViewModel = homeViewController.homeViewModel
//            cell.homeViewController = homeViewController
//            cell.selectionStyle = .none
//            return cell
            
        case .FeatureProduct:
            print("feature")
            cell.featuredProductCollectionModel = ((item as? HomeViewModelFeatureItem)?.featuredProductCollectionModel)!
            cell.ProductLabel.text = "Featured Products"
            break
            
        case .RecentViewData:
            /*let cell:RecentViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: RecentViewTableViewCell.identifier) as! RecentViewTableViewCell
            cell.recentCollectionModel = ((item as? HomeViewModelRecentViewItem)?.recentViewProductData)!
            cell.recentViewCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell*/
            break
        case .hotDeal:
            break
//            let cell:HotdealsTableViewCell = tableView.dequeueReusableCell(withIdentifier: HotdealsTableViewCell.identifier) as! HotdealsTableViewCell
//            cell.hotdealCollectionModel = ((item as? HomeViewModelHotdealItem)?.hotDealsProduct)!
//            cell.hotdelalCollectionView.reloadData()
//            cell.delegate = homeViewController
//            cell.selectionStyle = .none
//            return cell
            
            //return UITableViewCell()

        case .AllProduct:
            print("all")
             cell.featuredProductCollectionModel = ((item as? HomeViewModelAllItem)?.allProductCollectionModel)!
            cell.ProductLabel.text = "All Products"
            break
             //return UITableViewCell()
        case .RecommendedProduct:
            print("recommended")
             cell.featuredProductCollectionModel = ((item as? HomeViewModelRecommendedItem)?.recommendedProductCollectionModel)!
            cell.ProductLabel.text = "Recommended Products"
            break
             //return UITableViewCell()
        }
        cell.homeViewModel = homeViewController.homeViewModel
        cell.homeViewController = homeViewController
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        let item = items[indexPath.section + 1]
        switch item.type {
        case .Banner:
            return SCREEN_WIDTH / 2
            
        case .FeatureCategory:
            return 120
            
        case .LatestProduct:
            return UITableViewAutomaticDimension
            
        case .FeatureProduct:
            return UITableViewAutomaticDimension
            
        case .RecentViewData:
            //return SCREEN_WIDTH / 2 + 140
            return 0;
        case .hotDeal:
            return SCREEN_WIDTH / 2 + 140
        case .AllProduct:
            return 120
        case .RecommendedProduct:
            return 120
        }
    }
}


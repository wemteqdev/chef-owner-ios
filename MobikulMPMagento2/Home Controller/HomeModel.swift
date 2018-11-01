//
//  HomeModel.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import Foundation
import UIKit

struct HomeModal {
    var bannerCollectionModel = [BannerData]()
    var latestProductCollectionModel = [Products]()
    var featuredProductCollectionModel = [Products]()
    var allProductCollectionModel = [Products]()
    var recommendedProductCollectionModel = [Products]()
    var featureCategories = [FeatureCategories]()
    var languageData = [Languages]()
    var hotDealsProduct = [Products]()
    var cateoryData:[String:AnyObject]!
    var categoryImage = [CategoryImage]()
    var storeData = [StoreData]()
    var currency :NSArray!
    var cmsData = [CMSdata]()
    var productcategory :JSON!
    
    var recentViewData = [Productcollection]()
    
    init?(data : JSON) {
        
        if var arrayData = data["bannerImages"].arrayObject{
            arrayData = (data["bannerImages"].arrayObject! as NSArray) as! [Any]
            bannerCollectionModel =  arrayData.map({(value) -> BannerData in
                return  BannerData(data:JSON(value))
            })
        }
       
        let arrayData2 = data["newProducts"].arrayObject! as NSArray
        latestProductCollectionModel =  arrayData2.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        let arrayData7 = data["recommendedProducts"].arrayObject! as NSArray
        recommendedProductCollectionModel =  arrayData7.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        let arrayData8 = data["allProducts"].arrayObject! as NSArray
        allProductCollectionModel =  arrayData8.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        let arrayData3 = data["featuredProducts"].arrayObject! as NSArray
        featuredProductCollectionModel =  arrayData3.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        
        let arrayData4 = data["featuredCategories"].arrayObject! as NSArray
        featureCategories =  arrayData4.map({(value) -> FeatureCategories in
            return  FeatureCategories(data:JSON(value))
        })
        
        let arrayData5 = data["hotDeals"].arrayObject! as NSArray
        hotDealsProduct =  arrayData5.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        
        let arrayData6 = data["categoryImages"].arrayObject! as NSArray
        categoryImage =  arrayData6.map({(value) -> CategoryImage in
            return  CategoryImage(data:JSON(value))
        })
        
        if var arrayData = data["storeData"].arrayObject{
            arrayData = (data["storeData"].arrayObject! as NSArray) as! [Any]
            storeData =  arrayData.map({(value) -> StoreData in
                return  StoreData(data:JSON(value))
            })
        }
        
        if data["allowedCurrencies"].arrayObject != nil{
            currency = data["allowedCurrencies"].arrayObject! as NSArray
        }

        if data["productcategory"] != nil{
            productcategory = data["productcategory"];
        }
        
        if var arrayData = data["cmsData"].arrayObject{
            arrayData = (data["cmsData"].arrayObject! as NSArray) as! [Any]
            cmsData =  arrayData.map({(value) -> CMSdata in
                return  CMSdata(data:JSON(value))
            })
        }
        self.cateoryData = data["categories"].dictionaryObject! as [String : AnyObject]
    }
}

struct BannerData{
    var bannerType:String!
    var imageUrl:String!
    var bannerId:String!
    var bannerName:String!
    var productId:String!
    
    init(data:JSON){
        bannerType = data["bannerType"].stringValue
        imageUrl  = data["url"].stringValue
        bannerId = data["categoryId"].stringValue
        bannerName = data["categoryName"].stringValue
        productId = data["productId"].stringValue
    }
}

struct FeatureCategories{
    var categoryID:String = ""
    var categoryName:String = ""
    var imageUrl:String = ""
    
    init(data:JSON) {
        self.categoryID = data["categoryId"].stringValue
        self.categoryName = data["categoryName"].stringValue
        self.imageUrl = data["url"].stringValue
    }
}

struct Products {
    var qty:Int = 0
    var hasOption:Int!
    var name:String!
    var price:String!
    var productID:String!
    var showSpecialPrice:String!
    var image:String!
    var isInRange:Int!
    var isInWishList:Bool!
    var originalPrice:Double!
    var specialPrice:Double!
    var formatedPrice:String!
    var typeID:String!
    var groupedPrice:String!
    var formatedMinPrice:String!
    var formatedMaxPrice:String!
    var wishlistItemId:String!
    var reviewCount:String!
    var rating:Double!
    var supplierName:String!
    var taxClass:String!
    var minAddToCartQty:String!
    var isMin:Bool!
    var discount:Int!
    var supplierId:String!
    var unit:String!
    var userStatus:Bool!
    var tierPrice:Double!
    var nonEditable:Bool!
    var moq:Int!
    init(data:JSON) {
        self.hasOption = data["hasOption"].intValue
        self.name = data["name"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productID = data["entityId"].stringValue
        self.showSpecialPrice = data["formatedFinalPrice"].stringValue
        self.image = data["thumbNail"].stringValue
        self.originalPrice =  data["price"].doubleValue
        self.specialPrice = data["finalPrice"].doubleValue
        self.isInRange = data["isInRange"].intValue
        self.isInWishList = data["isInWishlist"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.typeID = data["typeId"].stringValue
        self.groupedPrice = data["groupedPrice"].stringValue
        self.formatedMaxPrice = data["formatedMaxPrice"].stringValue
        self.minAddToCartQty = data["minAddToCartQty"].stringValue
        
        self.formatedMinPrice = data["formatedMinPrice"].stringValue
        self.wishlistItemId = data["wishlistItemId"].stringValue
        self.taxClass = data["tax_class"].stringValue
        if self.taxClass == "" {
            self.taxClass = "No Tax Class"
        }
        self.supplierName = data["suppliername"].stringValue
        if self.supplierName == "" {
            self.supplierName = "No Supplier"
        }
        self.rating = data["rating"].doubleValue
        self.reviewCount = data["reviewcount"].stringValue
        self.isMin = data["min"].boolValue
        if self.isMin == nil {
            self.isMin = true
        }
        self.tierPrice = data["tierPrice"].doubleValue
        self.supplierId = data["supplierId"].stringValue
        self.discount = data["discount"].intValue
        self.unit = data["unitString"].stringValue
        self.userStatus = data["userStatus"].boolValue
        self.nonEditable = data["nonEditable"].boolValue
        if self.nonEditable == nil
        {
            self.nonEditable = false
        }
        self.moq = data["moq"].intValue
        if self.moq == nil {
            self.moq = 0
        }
    }
}

struct StoreData{
    var id:String = ""
    var name:String = ""
    var stores = [Languages]()
    
    init(data:JSON) {
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        
        if let arrayData = data["stores"].arrayObject{
            stores =  arrayData.map({(value) -> Languages in
                return  Languages(data:JSON(value))
            })
        }
    }
}

struct Languages {
    var code:String!
    var name:String!
    var id:String!
    
    init(data:JSON){
        self.code = data["code"].stringValue
        self.name = data["name"].stringValue
        self.id = data["id"].stringValue
    }
}

struct CategoryImage{
    var bannerImage:String = ""
    var id:String = ""
    var iconImage:String = ""
    
    init(data:JSON) {
        self.bannerImage = data["banner"].stringValue
        self.id = data["id"].stringValue
        self.iconImage = data["thumbnail"].stringValue
    }
}

struct CMSdata{
    var id:String!
    var title:String!
    
    init(data:JSON) {
        self.id = data["id"].stringValue
        self.title = data["title"].stringValue
    }
}

enum HomeViewModelItemType {
    
    //case Category
    case Banner
    case FeatureCategory
    case LatestProduct
    case FeatureProduct
    case RecentViewData
    case hotDeal
    case AllProduct
    case RecommendedProduct
}

protocol HomeViewModelItem {
    var type: HomeViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class HomeViewModelBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .Banner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return bannerCollectionModel.count
    }
    
    var bannerCollectionModel = [BannerData]()
    
    init(categories: [BannerData]) {
        self.bannerCollectionModel = categories
    }
}

class HomeViewModelFeatureCategoriesItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .FeatureCategory
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return featureCategories.count
    }
    
    var featureCategories = [FeatureCategories]()
    
    init(categories: [FeatureCategories]) {
        self.featureCategories = categories
    }
}

class HomeViewModelLatestItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .LatestProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return latestProductCollectionModel.count
    }
    
    var latestProductCollectionModel = [Products]()
    
    init(categories: [Products]) {
        self.latestProductCollectionModel = categories
    }
}

class HomeViewModelFeatureItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .FeatureProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return featuredProductCollectionModel.count
    }
    
    var featuredProductCollectionModel = [Products]()
    
    init(categories: [Products]) {
        self.featuredProductCollectionModel = categories
    }
}
class HomeViewModelRecommendedItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .RecommendedProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return recommendedProductCollectionModel.count
    }
    
    var recommendedProductCollectionModel = [Products]()
    
    init(categories: [Products]) {
        self.recommendedProductCollectionModel = categories
    }
}
class HomeViewModelAllItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .AllProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return allProductCollectionModel.count
    }
    
    var allProductCollectionModel = [Products]()
    
    init(categories: [Products]) {
        self.allProductCollectionModel = categories
    }
}

class HomeViewModelRecentViewItem: HomeViewModelItem    {
    var type: HomeViewModelItemType {
        return .RecentViewData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return recentViewProductData.count
    }
    
    var recentViewProductData = [Productcollection]()
    
    init(categories: [Productcollection]) {
        self.recentViewProductData = categories
    }
}

class HomeViewModelHotdealItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .hotDeal
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return hotDealsProduct.count
    }
    
    var hotDealsProduct = [Products]()
    
    init(categories: [Products]) {
        self.hotDealsProduct = categories
    }
}

class HomeViewModel : NSObject {
    
    var items = [HomeViewModelItem]()
    var featuredProductCollectionModel = [Products]()
    var letestProductCollectionModel = [Products]()
    var cateoryData:[String:AnyObject]!
    var currency :NSArray = []
    var languageData = [Languages]()
    var homeViewController:ViewController!
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
            items.append(featureCategoryCollectionItem)
        }
        
        if !data.featuredProductCollectionModel.isEmpty {
            featuredProductCollectionModel = data.featuredProductCollectionModel;
        }
        
        let latestCollectionItem = HomeViewModelLatestItem(categories: data.latestProductCollectionModel)
        items.append(latestCollectionItem)
        letestProductCollectionModel = data.latestProductCollectionModel
        
        if !recentViewData.isEmpty {
            let recentViewCollectionItem = HomeViewModelRecentViewItem(categories: recentViewData)
            items.append(recentViewCollectionItem)
        }
        
        if !data.hotDealsProduct.isEmpty {
            let hotDealCollectionItem = HomeViewModelHotdealItem(categories: data.hotDealsProduct)
            items.append(hotDealCollectionItem)
        }
        
        if data.currency != nil{
            self.currency = data.currency
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

extension HomeViewModel : UITableViewDelegate , UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int{
        return items.count ;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .Banner:
            let cell:BannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as! BannerTableViewCell
            cell.delegate = homeViewController
            cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
            cell.selectionStyle = .none
            return cell;
            
        case .FeatureCategory:
            let cell:TopCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as! TopCategoryTableViewCell
            cell.featureCategoryCollectionModel = ((item as? HomeViewModelFeatureCategoriesItem)?.featureCategories)!
            cell.categoryCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell
            
        case .LatestProduct:
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
            cell.prodcutCollectionView.reloadData()
            cell.prodcutCollectionView.tag = indexPath.section
            cell.productCollectionModel = letestProductCollectionModel
            cell.delegate = homeViewController
            cell.featuredProductCollectionModel = featuredProductCollectionModel
            cell.homeViewModel = homeViewController.homeViewModel
            cell.homeViewController = homeViewController
            cell.selectionStyle = .none
            return cell
            
        case .FeatureProduct:
            return UITableViewCell()
            
        case .RecentViewData:
            let cell:RecentViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: RecentViewTableViewCell.identifier) as! RecentViewTableViewCell
            cell.recentCollectionModel = ((item as? HomeViewModelRecentViewItem)?.recentViewProductData)!
            cell.recentViewCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell
        case .hotDeal:
            let cell:HotdealsTableViewCell = tableView.dequeueReusableCell(withIdentifier: HotdealsTableViewCell.identifier) as! HotdealsTableViewCell
            cell.hotdealCollectionModel = ((item as? HomeViewModelHotdealItem)?.hotDealsProduct)!
            cell.hotdelalCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell
            
            return UITableViewCell()
        case .AllProduct:
           return UITableViewCell()
        case .RecommendedProduct:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
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
            return SCREEN_WIDTH / 2 + 140
            
        case .hotDeal:
            return SCREEN_WIDTH / 2 + 140
        case .AllProduct:
            return 120
        case .RecommendedProduct:
            return 120
        }
    }
}

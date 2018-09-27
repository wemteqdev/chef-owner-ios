//
//  CatalogProductModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 12/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CatalogProductModel: NSObject {
    var productName:String!
    var formatedFinalPrice:String!
    var formatedSpecialprice:String!
    var rating:String!
    var descriptionData:String!
    var shortDescription:String!
    var specialPrice:Double = 0
    var price:Double = 0
    var additionalInformation:Array<JSON>!
    var bundleData:JSON
    var configurableData:JSON
    var customeOptionData:JSON
    var groupedData:JSON!
    var ratingFormData:Array<JSON>
    var links:JSON!
    var priceFormat:[String:AnyObject]!
    var shareUrl:String!
    var ratingData:Array<Any>!
    var reviewList:Array<Any>!
    var stockMessage:String!
    var isInRange:Bool!
    var formatedPrice:String!
    var isInWishList:Bool!
    var wishlistItemId:String!
     var isAvailable:Bool = true
//    var ratingsData = [RatingsData]()
    var typeID:String!
    var groupedPrice:String!
    var formatedMinPrice:String!
    var formatedMaxPrice:String!
    
    init(data: JSON) {
        self.productName = data["name"].stringValue
        self.formatedFinalPrice = data["formatedFinalPrice"].stringValue
        self.formatedSpecialprice = data["formatedFinalPrice"].stringValue
        self.rating = data["rating"].stringValue
        self.descriptionData = data["description"].stringValue
        self.shortDescription = data["shortDescription"].stringValue.html2String
        self.specialPrice = data["finalPrice"].doubleValue
        self.price = data["price"].doubleValue
        self.additionalInformation = data["additionalInformation"].arrayValue
        self.bundleData = data
        self.configurableData = data
        self.customeOptionData = data
        self.priceFormat = data["priceFormat"].dictionaryObject! as [String : AnyObject]
        self.shareUrl = data["productUrl"].stringValue
        self.groupedData = data
        self.ratingData = data["ratingData"].arrayObject
        self.ratingFormData = data["ratingFormData"].arrayValue
        self.reviewList = data["reviewList"].arrayObject
        self.stockMessage = data["availability"].stringValue
        self.links = data
        self.isInRange = data["isInRange"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.isInWishList = data["isInWishlist"].boolValue
        self.wishlistItemId = data["wishlistItemId"].stringValue
        self.isAvailable = data["isAvailable"].boolValue
        self.typeID = data["typeId"].stringValue
        self.groupedPrice = data["groupedPrice"].stringValue
        self.formatedMaxPrice = data["formatedMaxPrice"].stringValue
        self.formatedMinPrice = data["formatedMinPrice"].stringValue
    }
}

class RelatedProducts:NSObject{
    
    var productName:String!
    var imageUrl:String!
    var hasOption:Int!
    var price:String!
    var productId:String!
    
    init(data:JSON){
        self.productName = data["name"].stringValue
        self.imageUrl = data["thumbNail"].stringValue
        self.hasOption = data["hasOptions"].intValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productId = data["entityId"].stringValue
    }
}

class ReviewList:NSObject{
    var reviewBy:String!
    var title:String!
    var details:String!
    var reviewOn:String!
    var ratingsData:Array<JSON>!
    
    init(data:JSON){
        self.reviewBy = data["reviewBy"].stringValue
        self.title = data["title"].stringValue
        self.details = data["details"].stringValue
        self.reviewOn = data["reviewOn"].stringValue
        self.ratingsData = data["ratings"].arrayValue
    }
}

struct AdditionalFeature{
    var label:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }
}

class bannerImage:NSObject{
    var bannerUrl:String = ""
    
    init(data: JSON) {
        self.bannerUrl = data["largeImage"].stringValue
    }
}

struct SellerRatingData{
    
    var label:String = ""
    var value:Float!
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].floatValue
    }
}

struct SellerInformationData{
    var sellerID:String = ""
    var sellerAverageRating:String = ""
    var sellerReviewDescription:String!
    var sellerShopTitle:String!
    
    
    init(data:JSON) {
        self.sellerID = data["sellerId"].stringValue
        self.sellerAverageRating = data["sellerAverageRating"].stringValue
        self.sellerReviewDescription = data["reviewDescription"].stringValue
        self.sellerShopTitle = data["shoptitle"].stringValue
    }
}

class CatalogProductViewModel:NSObject{
    
    var bannerImageModel:Array = [String]();
    var relatedProduct = [RelatedProducts]()
    var reviewList = [ReviewList]()
    var additionalFeature = [AdditionalFeature]()
    var sellerRatingData = [SellerRatingData]()
    var catalogProductModel:CatalogProductModel!
    var sellerInformationData:SellerInformationData!
    
    init(data:JSON) {
        for i in 0..<data["imageGallery"].count{
            let dict = data["imageGallery"][i];
            bannerImageModel.append(dict["largeImage"].stringValue)
        }
        let arrayData = data["relatedProductList"].arrayObject! as NSArray
        relatedProduct =  arrayData.map({(value) -> RelatedProducts in
            return  RelatedProducts(data:JSON(value))
        })
        
        let arrayData1 = data["reviewList"].arrayObject! as NSArray
        reviewList =  arrayData1.map({(value) -> ReviewList in
            return  ReviewList(data:JSON(value))
        })
        
        if let arrayData = data["additionalInformation"].arrayObject{
            additionalFeature =  arrayData.map({(value) -> AdditionalFeature in
                return  AdditionalFeature(data:JSON(value))
            })
        }
        if let arrayData = data["sellerRating"].arrayObject{
            sellerRatingData =  arrayData.map({(value) -> SellerRatingData in
                return  SellerRatingData(data:JSON(value))
            })
        }
        
        catalogProductModel = CatalogProductModel(data:data)
        sellerInformationData = SellerInformationData(data:data)
    }
    
    var getBannerImageUrl:Array<String>{
        return bannerImageModel
    }
    
    var getRelatedProducts:Array<RelatedProducts>{
        return relatedProduct
    }
    
    var getReviewListData:Array<ReviewList>{
        return reviewList;
    }
    
    var getRatingsData:Array<Any>{
        return catalogProductModel.ratingData;
    }
}

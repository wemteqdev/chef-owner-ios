//
//  SellerDetailsModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct SellerRecentProduct{
    var productName:String = ""
    var productImage:String = ""
    var descriptionData:String = ""
    var id:String = ""
    var price:String = ""
    var rating:CGFloat!
    var isInWishlist:Bool!
    var isInRange:Bool!
    var formatedPrice:String = ""
    var specialPrice:Double = 0
    var normalprice:Double = 0
    var formatedSpecialPrice:String = ""
    var qty:String!
    var hasOption:Int = 0
    
    init(data: JSON) {
        self.productImage = data["thumbNail"].stringValue
        self.descriptionData = data["shortDescription"].stringValue.html2String
        self.id = data["entityId"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productName = data["name"].stringValue
        self.rating = CGFloat(data["rating"].floatValue)
        self.isInWishlist = data["isInWishlist"].boolValue
        self.isInRange = data["isInRange"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.specialPrice = data["finalPrice"].doubleValue
        self.normalprice = data["price"].doubleValue
        self.formatedSpecialPrice = data["formatedFinalPrice"].stringValue
        self.qty = "1";
        self.hasOption = data["hasOptions"].intValue
        
    }
  
    
}


struct SellerFeedBackList{
    
    var description:String = ""
    var date:String = ""
    var name:String = ""
    var pricerating:Int!
    var qualityrating:Int!
    var valuerating:Int!
    var summary:String!
    
    init(data:JSON) {
        self.description = data["description"].stringValue
        self.date = data["date"].stringValue
        self.name = data["userName"].stringValue
        self.pricerating = data["feedPrice"].intValue/20
        self.qualityrating = data["feedQuality"].intValue/20
        self.valuerating = data["feedValue"].intValue/20
        self.summary = data["summary"].stringValue
    }
    
    
    
    
}




struct SellerProfileExtraDetailsData{
    var averagePriceRating:String!
    var averageQualityRating:String!
    var averageRating:String!
    var averageRatingFloatValue:Double!
    var averageValueRating:String!
    var bannerImage:String!
    var description:String!
    var location:String!
    var profileImage:String!
    var quality1Star:Float = 0;
    var quality2Star:Float = 0;
    var quality3Star:Float = 0;
    var quality4Star:Float = 0;
    var quality5Star:Float = 0;
    var price1Star:Float = 0;
    var price2Star:Float = 0;
    var price3Star:Float = 0;
    var price4Star:Float = 0;
    var price5Star:Float = 0;
    var returnPolicy:String!
    var shopTitle:String!
    var shopUrl:String!
    var shippingPolicy:String!
    var value1Star:Float = 0;
    var value2Star:Float = 0;
    var value3Star:Float = 0;
    var value4Star:Float = 0;
    var value5Star:Float = 0;
    var feedbackcount:String!
    
    var facebookId : String = ""
    var twitterId : String = ""
    
    init(data:JSON) {
        self.averagePriceRating = data["averagePriceRating"].stringValue
        self.averageQualityRating = data["averageQualityRating"].stringValue
        self.averageRating = data["averageRating"].stringValue
        self.averageValueRating = data["averageValueRating"].stringValue
        self.bannerImage = data["bannerImage"].stringValue
        self.description = data["description"].stringValue
        self.location = data["location"].stringValue
        self.profileImage = data["profileImage"].stringValue
        self.quality1Star = data["quality1Star"].floatValue
        self.quality2Star = data["quality2Star"].floatValue
         self.quality3Star = data["quality3Star"].floatValue ;
        self.quality4Star = data["quality4Star"].floatValue ;
        self.quality5Star = data["quality5Star"].floatValue
        self.returnPolicy = data["returnPolicy"].stringValue
        self.price1Star = data["price1Star"].floatValue;
        self.price2Star = data["price2Star"].floatValue;
        self.price3Star = data["price3Star"].floatValue;
        self.price4Star = data["price4Star"].floatValue;
        self.price5Star = data["price5Star"].floatValue;
        self.shippingPolicy = data["shippingPolicy"].stringValue
        self.shopTitle = data["shopTitle"].stringValue
        self.shopUrl = data["shopUrl"].stringValue
        self.value1Star = data["value1Star"].floatValue
        value2Star = data["value2Star"].floatValue
        value3Star = data["value3Star"].floatValue
        value4Star = data["value4Star"].floatValue
        value5Star = data["value5Star"].floatValue
        feedbackcount = data["feedbackCount"].stringValue
        self.averageRatingFloatValue = data["averageRating"].doubleValue
        
        self.facebookId = data["facebookId"].stringValue
        self.twitterId = data["twitterId"].stringValue
    }
}







class SellerProfileDetailsViewModel: NSObject{
    var sellerRecentProduct = [SellerRecentProduct]()
    var sellerFeedBackList = [SellerFeedBackList]()
    var sellerProfileExtraDetailsData:SellerProfileExtraDetailsData!
    
    init(data:JSON) {
        if let arrayData = data["recentProductList"].arrayObject{
            sellerRecentProduct =  arrayData.map({(value) -> SellerRecentProduct in
                return  SellerRecentProduct(data:JSON(value))
            })
        }
        if let arrayData = data["reviewList"].arrayObject{
            sellerFeedBackList =  arrayData.map({(value) -> SellerFeedBackList in
                return  SellerFeedBackList(data:JSON(value))
            })
        }
        sellerProfileExtraDetailsData = SellerProfileExtraDetailsData(data:data)
        
    }
    
    
}




























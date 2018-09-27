//
//  SellerEditProfileModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 26/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct SellerEditProfileData{
    var backgroundColorHint:String!
    var bannerHint:String!
    var bannerImage:String!
    var companyDescription:String!
    var companyDescriptionHint:String!
    var companyLocality:String!
    var companyLocalityHint:String!
    var contactNumber:String!
    var contactNumberHint:String!
    var country:String!
    var countryHint:String!
    var facebookHint:String!
    var facebookId:String!
    var flagImageUrl:String!
    var googleplusId:String!
    var instagramId:String!
    var isFacebookActive:Bool!
    var isInstagramActive:Bool!
    var isPinterestActive:Bool!
    var isTwitterActive:Bool!
    var isVimeoActive:Bool!
    var isYoutubeActive:Bool!
    var isgoogleplusActive:Bool!
    var metaDescription:String!
    var metaDescriptionHint:String!
    var metaKeyword:String!
    var metaKeywordHint:String!
    var paymentDetails:String!
    var paymentDetailsHint:String!
    var pinterestId:String!
    var profileImage:String!
    var profileImageHint:String!
    var returnPolicy:String!
    var returnPolicyHint:String!
    var shippingPolicy:String!
    var shippingPolicyHint:String!
    var shopTitle:String!
    var shopTitleHint:String!
    var taxvat:String!
    var taxvatHint:String!
    var twitterHint:String!
    var twitterId:String!
    var vimeoId:String!
    var youtubeId:String!
    var backgroundColor:String!
    
    init(data:JSON) {
        backgroundColorHint = data["backgroundColorHint"].stringValue
        bannerHint = data["bannerHint"].stringValue
        bannerImage = data["bannerImage"].stringValue
        companyDescription = data["companyDescription"].stringValue
        companyDescriptionHint = data["companyDescriptionHint"].stringValue
        companyLocality = data["companyLocality"].stringValue
        companyLocalityHint = data["companyLocalityHint"].stringValue
        contactNumber = data["contactNumber"].stringValue
        contactNumberHint = data["contactNumberHint"].stringValue
        country = data["country"].stringValue
        countryHint = data["countryHint"].stringValue
        facebookHint = data["facebookHint"].stringValue
        facebookId = data["facebookId"].stringValue
        flagImageUrl = data["flagImageUrl"].stringValue
        googleplusId = data["googleplusId"].stringValue
        instagramId = data["instagramId"].stringValue
        isFacebookActive = data["isFacebookActive"].boolValue
        isInstagramActive = data["isInstagramActive"].boolValue
        isPinterestActive  = data["isPinterestActive"].boolValue
        isTwitterActive = data["isTwitterActive"].boolValue
        isVimeoActive = data["isVimeoActive"].boolValue
        isYoutubeActive = data["isYoutubeActive"].boolValue
        isgoogleplusActive = data["isgoogleplusActive"].boolValue
        metaDescription = data["metaDescription"].stringValue
        metaDescriptionHint  = data["metaDescriptionHint"].stringValue
        metaKeyword = data["metaKeyword"].stringValue
        metaKeywordHint = data["metaKeywordHint"].stringValue
        paymentDetails = data["paymentDetails"].stringValue
        paymentDetailsHint = data["paymentDetailsHint"].stringValue
        pinterestId = data["pinterestId"].stringValue
        profileImage = data["profileImage"].stringValue
        profileImageHint = data["profileImageHint"].stringValue
        returnPolicy = data["returnPolicy"].stringValue
        returnPolicyHint = data["returnPolicyHint"].stringValue
        shippingPolicy = data["shippingPolicy"].stringValue
        shippingPolicyHint = data["shippingPolicyHint"].stringValue
        shopTitle = data["shopTitle"].stringValue
        shopTitleHint = data["shopTitleHint"].stringValue
        taxvat = data["taxvat"].stringValue
        taxvatHint = data["taxvatHint"].stringValue
        twitterHint = data["twitterHint"].stringValue
        twitterId = data["twitterId"].stringValue
        vimeoId = data["vimeoId"].stringValue
        youtubeId = data["youtubeId"].stringValue
        self.backgroundColor = data["backgroundColor"].stringValue
    }
    
    
    
}



struct SellerCountryData{
    var is_region_visible:Bool!
    var label:String!
    var value:String!
    
    init(data:JSON) {
        self.is_region_visible = data["is_region_visible"].boolValue
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }
    
    
    
}




class SellerEditProfileViewModel:NSObject{
    var sellerCountryData = [SellerCountryData]()
    var sellerEditProfileData:SellerEditProfileData!
    
    init(data:JSON) {
        if let arrayData = data["countryList"].arrayObject{
            sellerCountryData =  arrayData.map({(value) -> SellerCountryData in
                return  SellerCountryData(data:JSON(value))
            })
        }
        
        sellerEditProfileData  = SellerEditProfileData(data:data)
    }
    
}







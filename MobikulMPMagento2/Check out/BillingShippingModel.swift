//
//  BillingShippingModel.swift
//  Magento2V4Theme
//
//  Created by kunal on 19/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation



struct ShippingAndBillingInfo{
    var isPrifixVisible:Bool!
    var isPrefixRequired:Bool!
    var isPrefixHasOption:Bool!
    var prefixOptions:Array<Any>
    var prefixValue:String!

    var isSuffixVisible:Bool!
    var isSuffixRequired:Bool!
    var isSuffixHasOption:Bool!
    var suffixOptions:Array<Any>
    var suffixValue:String!
    
    var isMiddleNameVisible:Bool!
    var middleName:String!
    
    var isGenderVisible:Bool!
    var isGenderRequired:Bool!
    
    var isDobVisible:Bool!
    var isDobRequired:Bool!
    var dobFormat:String!
    
    
    var isTaxVisible:Bool!
    var isTaxRequired:Bool!
    
    var lastName:String!
    var firstName:String!
    
    var streetCount:Int!
    
    
    init(data:JSON) {
        self.isPrifixVisible = data["isPrefixVisible"].boolValue
        self.isPrefixRequired = data["isPrefixRequired"].boolValue
        self.prefixValue = data["prefixValue"].stringValue
        self.isPrefixHasOption = data["prefixHasOptions"].boolValue
        self.prefixOptions = data["prefixOptions"].arrayObject!
        
        
        self.isSuffixVisible = data["isSuffixVisible"].boolValue
        self.isSuffixRequired = data["isSuffixRequired"].boolValue
        self.isSuffixHasOption = data["suffixHasOptions"].boolValue
        self.suffixOptions = data["suffixOptions"].arrayObject!
        self.suffixValue = data["suffixValue"].stringValue
        
        self.isMiddleNameVisible = data["isMiddlenameVisible"].boolValue
        self.middleName = data["middleName"].stringValue
        
        self.isGenderVisible = data["isGenderVisible"].boolValue
        self.isGenderRequired = data["isGenderRequired"].boolValue
        
        self.isDobVisible = data["isDOBVisible"].boolValue
        self.isDobRequired = data["isDOBRequired"].boolValue
        self.dobFormat = data["dateFormat"].stringValue
        
        
        self.isTaxVisible =  data["isTaxVisible"].boolValue
        self.isTaxRequired = data["isTaxRequired"].boolValue
        
        self.lastName = data["lastName"].stringValue
        self.firstName = data["firstName"].stringValue
        
        self.streetCount = data["streetLineCount"].intValue
    }
}



struct AddressData{
    var id:String!
    var value:String!
    
    init(data:JSON) {
        self.id = data["id"].stringValue
        self.value = data["value"].stringValue
    }
    
}


struct CountryData{
    var countryId:String!
    var name:String!
    var stateData = [StateData]()
    
    
    init(data:JSON) {
        self.countryId = data["country_id"].stringValue
        self.name = data["name"].stringValue
        
       if let arrayData = data["states"].arrayObject{
        stateData =  arrayData.map({(value) -> StateData in
            return  StateData(data:JSON(value))
        })
      }
    }
}




struct StateData{
    var regionCode:String!
    var name:String!
    var regionId:String!
    
    init(data:JSON){
       self.regionCode = data["code"].stringValue
       self.name = data["name"].stringValue
       self.regionId = data["region_id"].stringValue
      
    }

}




class BillingAndShipingViewModel{
    var billingShippingModel:ShippingAndBillingInfo!
    var countryData = [CountryData]()
    var addressData = [AddressData]()
    
    init(data:JSON) {
        if let arrayData = data["countryData"].arrayObject{
            countryData = arrayData.map({(value) -> CountryData in
                return CountryData(data:JSON(value))
            })
        }
        
        if let arrayData = data["address"].arrayObject{
            addressData =  arrayData.map({(value) -> AddressData in
                return  AddressData(data:JSON(value))
            })
        }
        
        billingShippingModel = ShippingAndBillingInfo(data: data)
    }
    
}









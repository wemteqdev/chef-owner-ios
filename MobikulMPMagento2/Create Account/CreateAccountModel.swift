//
//  CreateAccountModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 18/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit


class CreateAccountModel: NSObject {
    var countryData = [CountryData]()

    var isDobRequired:Bool!
    var isDobVisible:Bool!
    var isGenderRequired:Bool!
    var isGenderVisible:Bool!
    var isMiddleNameVisible:Bool!
    var isMobileNumberVisible:Bool!
    var isMobileNumberRequired:Bool!
    var isPrefixRequired:Bool!
    var isPrefixVisible:Bool!
    var isSuffixRequired:Bool!
    var isSuffixVisible:Bool!
    var isTaxRequired:Bool!
    var isTaxVisible:Bool!
    var isPrefixHasOption:Bool!
    var isSuffixHasOption:Bool!
    var prefixValue:Array<Any>!
    var suffixValue:Array<Any>!
    var dateFormat:String!
    
    init(data: JSON) {
        if let arrayData = data["countryData"].arrayObject{
            countryData = arrayData.map({(value) -> CountryData in
                return CountryData(data:JSON(value))
            })
        }
        
     self.dateFormat = data["dateFormat"].stringValue
     self.isDobRequired = data["isDOBRequired"].boolValue
     self.isDobVisible = data["isDOBVisible"].boolValue
     self.isGenderRequired = data["isGenderRequired"].boolValue
     self.isGenderVisible = data["isGenderVisible"].boolValue
     self.isMiddleNameVisible = data["isMiddlenameVisible"].boolValue
     self.isMobileNumberRequired = data["isMobileRequired"].boolValue
     self.isMobileNumberVisible = data["isMobileVisible"].boolValue
     self.isPrefixRequired = data["isPrefixRequired"].boolValue
     self.isPrefixVisible = data["isPrefixVisible"].boolValue
     self.isSuffixRequired = data["isSuffixRequired"].boolValue
     self.isSuffixVisible = data["isSuffixVisible"].boolValue
     self.isTaxRequired = data["isTaxRequired"].boolValue
     self.isTaxVisible = data["isTaxVisible"].boolValue
     self.isPrefixHasOption = data["prefixHasOptions"].boolValue
     self.isSuffixHasOption = data["suffixHasOptions"].boolValue
     self.prefixValue = data["prefixOptions"].arrayObject
     self.suffixValue = data["suffixOptions"].arrayObject
    
    }

}
 

//
//  AddeditAddressModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 22/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AddeditAddressModel: NSObject {
    var isMiddleNameVisible:Bool!
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
    var receiveMiddleName:String!
    var receivePrefixValue:String!
    var receiveSuffixValue:String!
    var receiveStreetCount:Int = 2
    var countryData:Array<Any>!
    var receiveFirstName:String!
    var receiveLastName:String!
    var receiveCompanyName:String!
    var receiveTelephoneValue:String!
    var faxValue:String!
    var receiveCity:String!
    var receivePostCode:String!
    var receiveStreetData:Array<Any>!
    var receiveIsDefaultBilling:Bool!
    var receiveIsDefaultShipping:Bool!
    var receiveCountryId:String!
    var receiveRegion:String!
    var receiveRegionId:String!
    var defaultCountryCode:String!

    
    

    init(data: JSON) {
        self.isMiddleNameVisible = data["isMiddlenameVisible"].boolValue
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
        self.receiveMiddleName = data["addressData"]["middlename"].stringValue
        self.receivePrefixValue = data["addressData"]["prefix"].stringValue
        self.receiveSuffixValue = data["addressData"]["suffix"].stringValue
        self.receiveStreetCount = data["streetLineCount"].intValue
        self.countryData = data["countryData"].arrayObject
        self.receiveFirstName = data["addressData"]["firstname"].stringValue
        self.receiveLastName = data["addressData"]["lastname"].stringValue
        receiveCompanyName = data["addressData"]["company"].stringValue
        receiveTelephoneValue = data["addressData"]["telephone"].stringValue
        faxValue = data["addressData"]["fax"].stringValue
        receiveCity = data["addressData"]["city"].stringValue
        receivePostCode = data["addressData"]["postcode"].stringValue
        receiveStreetData = data["addressData"]["street"].arrayObject
        receiveIsDefaultBilling = data["addressData"]["isDefaultBilling"].boolValue
        receiveIsDefaultShipping = data["addressData"]["isDefaultShipping"].boolValue
        receiveCountryId = data["addressData"]["country_id"].stringValue
        receiveRegion = data["addressData"]["region"].stringValue
        receiveRegionId = data["addressData"]["region_id"].stringValue
        self.defaultCountryCode = data["defaultCountry"].stringValue
        
    }
    
    
    

}

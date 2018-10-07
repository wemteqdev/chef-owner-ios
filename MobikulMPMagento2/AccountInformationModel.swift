//
//  AccountInformationModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 21/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AccountInformationModel: NSObject {
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
    var dobValue:String!
    var emailId:String!
    var firstName:String!
    var genderValue:Int!
    var lastName:String!
    var middleName:String!
    var mobileNumber:String!
    var receivePrefixValue:String!
    var receiveSuffixValue:String!
    var taxValue:String!
    var city:String!
    var state:String!
    var street:String!
    var postcode:String!
    var country:String!
    
    init(data: JSON) {
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
        self.dobValue = data["DOBValue"].stringValue
        self.emailId = data["email"].stringValue
        self.firstName = data["firstName"].stringValue
        self.genderValue = data["genderValue"].intValue
        self.lastName = data["lastName"].stringValue
        self.middleName = data["middleName"].stringValue
        self.mobileNumber = data["mobile"].stringValue
        self.receivePrefixValue = data["prefixValue"].stringValue
        self.receiveSuffixValue = data["suffixValue"].stringValue
        self.taxValue = data["taxValue"].stringValue
        self.city = data["city"].stringValue
        self.state = data["state"].stringValue
        self.street = data["street"][0].stringValue
        self.postcode = data["postcode"].stringValue
        self.country = data["country"].stringValue
    }

    

}

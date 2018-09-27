//
//  AddressBookModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 22/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AddressBookModel: NSObject {
    var billingAddress:String!
    var billingId:Int!
    var billingIdValue:String!
    var shippingIdValue:String!
    var shippingAddress:String!
    var shippingId:Int!
    init(data: JSON) {
       self.billingAddress = data["billingAddress"]["value"].stringValue.html2String
       self.shippingAddress = data["shippingAddress"]["value"].stringValue.html2String
       self.billingId = data["billingAddress"]["id"].intValue
       self.shippingId = data["shippingAddress"]["id"].intValue
       self.billingIdValue = data["billingAddress"]["id"].stringValue
       self.shippingIdValue = data["shippingAddress"]["id"].stringValue
    }
    

}


class AdditionalAddressEntries:NSObject{
    var id:String!
    var value:String!
    init(data:JSON ) {
        self.id = data["id"].stringValue
        self.value = data["value"].stringValue.html2String
    }
}


class AddressBookViewModel:NSObject{
    var additionalAddressCollection = [AdditionalAddressEntries]()
    var addressBookModel:AddressBookModel!
    init(data:JSON) {
        for i in 0..<data["additionalAddress"].count{
            let dict = data["additionalAddress"][i];
            additionalAddressCollection.append(AdditionalAddressEntries(data: dict))
        }
        
       addressBookModel = AddressBookModel(data: data)
        
    }
    
    
    
}




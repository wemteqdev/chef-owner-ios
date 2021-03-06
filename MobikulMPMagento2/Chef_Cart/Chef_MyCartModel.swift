//
//  Chef_MyCartModel.swift
//  MobikulMPMagento2
//
//  Created by Othello on 20/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_MyCartModel: NSObject {
    var id:String = ""
    var imageUrl:String = ""
    var name:String!
    var price:String!
    var productId:String!
    var qty:String!
    var subtotal:String!
    var options:Array<JSON>
    var message:JSON!
    var supplierId:String = ""
    var rating:Double!
    var reviewCount:String = ""
    var unit:String = ""
    var unitMeasurement:Int = 1
    var tier_price:Double!
    var moq:Int!
    var priceint:Double!
    var tierSubtotal:String = ""
    var unitString:String = ""
    var taxClass:String!
    init(data:JSON) {
        self.id = data["id"].stringValue
        self.imageUrl = data["image"].stringValue
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.productId = data["productId"].stringValue
        self.qty = data["qty"].stringValue
        self.subtotal = data["subTotal"].stringValue
        self.options = data["options"].arrayValue
        self.message = data["messages"]
        self.supplierId = data["supplierId"].stringValue
        self.rating = data["rating"].doubleValue
        self.reviewCount = data["reviewcount"].stringValue
        self.unit = data["unit"].stringValue
        
        self.unitMeasurement = data["unitMeasurement"].intValue
        self.taxClass = data["tax_class"].stringValue
        if self.taxClass == "" {
            self.taxClass = "No Tax Class"
        }
        self.tier_price = data["tier_price"].doubleValue
        if(self.tier_price == nil){
            self.tier_price = 0
        }
        self.moq = data["moq"].intValue
        if self.moq == nil {
            self.moq = 0
        }
        self.priceint = data["priceint"].doubleValue
        self.tierSubtotal = data["tier_subtotal"].stringValue
        self.unitString = data["unitString"].stringValue
        
        
    }
}

class Chef_ExtraCartData:NSObject{
    var discountValue:String!
    var discountLabel:String!
    var grandLabel:String!
    var grandValue:String!
    var grandUnformatedValue:Float!
    var shippingLabel:String!
    var shippingValue:String!
    var taxLabel:String!
    var taxValue:String!
    var subTotalLabel:String!
    var subTotalValue:String!
    var cartCount:Int!
    var couponCode:String!
    var isVirtual:Int!
    var minimumAmount:Float!
    var minimumFormattedAmount:String!
    var isAllowedGuestCheckout:Bool!
    
    init(data:JSON){
        self.discountLabel = data["discount"]["title"].stringValue
        self.discountValue = data["discount"]["value"].stringValue
        self.grandLabel = data["grandtotal"]["title"].stringValue
        self.grandValue = data["grandtotal"]["value"].stringValue
        self.grandUnformatedValue = data["grandtotal"]["unformatedValue"].floatValue
        self.shippingLabel = data["shipping"]["title"].stringValue
        self.shippingValue = data["shipping"]["value"].stringValue
        self.taxLabel = data["tax"]["title"].stringValue
        self.taxValue = data["tax"]["value"].stringValue
        self.subTotalLabel = data["subtotal"]["title"].stringValue
        self.subTotalValue = data["subtotal"]["value"].stringValue
        self.cartCount = data["cartCount"].intValue
        self.couponCode = data["couponCode"].stringValue
        self.isVirtual = data["isVirtual"].intValue
        self.minimumAmount = data["minimumAmount"].floatValue
        self.minimumFormattedAmount = data["minimumFormattedAmount"].stringValue
        self.isAllowedGuestCheckout = data["isAllowedGuestCheckout"].boolValue
    }
}

class Chef_MyCartViewModel:NSObject{
    var myCartModel = [Chef_MyCartModel]()
    var myCartExtraData:ExtraCartData!
    
    init(data:JSON){
        let arrayData = data["items"].arrayObject! as NSArray
        myCartModel =  arrayData.map({(value) -> Chef_MyCartModel in
            return  Chef_MyCartModel(data:JSON(value))
        })
        myCartExtraData = ExtraCartData(data: data)
    }
    
    var getCartItems:Array<Chef_MyCartModel>{
        return myCartModel
    }
    
    var getExtraCartData:ExtraCartData{
        return myCartExtraData
    }
    
    func setQtyDataToCartModel(data:String,pos:Int){
        myCartModel[pos].qty = data
    }
}

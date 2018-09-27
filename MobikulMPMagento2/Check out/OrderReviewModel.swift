//
//  OrderReviewModel.swift
//  Magento2V4Theme
//
//  Created by kunal on 20/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct ExtraOrderReviewData{
    var billingAddress:String = ""
    var shippingAddress:String = ""
    var grandTotalLabel:String = ""
    var grandTotalValue:String = ""
    var paymentMethod:String = ""
    var shippingMethod:String = ""
    var shippingChargeLabel:String = ""
    var shippingChargeValue:String = ""
    var subtotalLabel:String = ""
    var subtotalValue:String = ""
    var taxLabel:String = ""
    var taxValue:String = ""
    var discountTitle:String!
    var discountValue:String!
    
    init(data:JSON) {
        self.billingAddress = data["billingAddress"].stringValue.html2String
        self.shippingAddress = data["shippingAddress"].stringValue.html2String
        self.paymentMethod = data["billingMethod"].stringValue
        self.shippingMethod = data["shippingMethod"].stringValue
        self.grandTotalLabel = data["orderReviewData"]["grandtotal"]["title"].stringValue
        self.grandTotalValue = data["orderReviewData"]["grandtotal"]["value"].stringValue
        
        self.shippingChargeLabel = data["orderReviewData"]["shipping"]["title"].stringValue
        self.shippingChargeValue = data["orderReviewData"]["shipping"]["value"].stringValue
        
        self.subtotalLabel = data["orderReviewData"]["subtotal"]["title"].stringValue
        self.subtotalValue = data["orderReviewData"]["subtotal"]["value"].stringValue
        
        self.taxLabel = data["orderReviewData"]["tax"]["title"].stringValue
        self.taxValue = data["orderReviewData"]["tax"]["value"].stringValue
        
        self.discountTitle = data["orderReviewData"]["discount"]["title"].stringValue
        self.discountValue = data["orderReviewData"]["discount"]["value"].stringValue
        
    }

}



struct OrderReviewProduct {
    var price:String = ""
    var productName:String = ""
    var qty:String = ""
    var subtotal:String = ""
    var imageUrl:String = ""
    var options:Array<JSON>
    
    init(data:JSON) {
        self.price = data["price"].stringValue
        self.productName = data["productName"].stringValue
        self.qty = data["qty"].stringValue
        self.subtotal = data["subTotal"].stringValue
        self.imageUrl = data["thumbNail"].stringValue
        self.options = data["option"].arrayValue
    }
    
    
}




class OrderReviewViewModel:NSObject{
    var orderReviewProduct = [OrderReviewProduct]()
    var orderReviewExtraData:ExtraOrderReviewData!
    
    init(data:JSON) {
        if let arrayData = data["orderReviewData"]["items"].arrayObject{
        orderReviewProduct =  arrayData.map({(value) -> OrderReviewProduct in
            return  OrderReviewProduct(data:JSON(value))
        })
    }
        
        orderReviewExtraData = ExtraOrderReviewData(data: data)
    
    }
    
    
    
    
}



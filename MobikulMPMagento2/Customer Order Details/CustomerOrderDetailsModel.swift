//
//  CustomerOrderDetailsModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 23/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CustomerOrderDetailsModel: NSObject {
    var billingAddress:String!
    var incrementId:String!
    var itemList:Array<Any>!
    var totals:Array<Any>!
    var orderDate:String!
    var paymentMethod:String!
    var shippingAddress:String!
    var shippingMethod:String!
    var status:String!
    
    init(data:JSON){
        self.billingAddress = data["billingAddress"].stringValue.html2String
        self.incrementId = data["incrementId"].stringValue
        self.totals = data["orderData"]["totals"].arrayObject
        self.orderDate = data["orderDate"].stringValue
        self.paymentMethod = data["paymentMethod"].stringValue
        self.shippingAddress = data["shippingAddress"].stringValue.html2String
        self.shippingMethod = data["shippingMethod"].stringValue
        self.status = data["statusLabel"].stringValue
    }
}


struct CustomerTotal{
    var label:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["formattedValue"].stringValue
    }
 
}



struct CustomerItemsData{
    var productName:String!
    var SubTotal:String!
    var price:String = ""
    var qty_Canceled:String = ""
    var qty_CanceledValue:Int = 0
    var qty_Ordered:String = ""
    var qty_OrderedValue:Int = 0
    var qty_Refunded:String = ""
    var qty_RefundedValue:Int = 0
    var qty_Shipped:String = ""
    var qty_ShippedValue:Int = 0
    var options:Array<JSON>
    
    init(data:JSON) {
        self.productName = data["name"].stringValue;
        self.SubTotal = data["subTotal"].stringValue;
        self.price = data["price"].stringValue;
        self.qty_Canceled = data["qty"]["Canceled"].stringValue;
        self.qty_CanceledValue = data["qty"]["Canceled"].intValue;
        self.qty_Ordered = data["qty"]["Ordered"].stringValue;
        self.qty_OrderedValue = data["qty"]["Ordered"].intValue;
        self.qty_Refunded = data["qty"]["Refunded"].stringValue;
        self.qty_RefundedValue = data["qty"]["Refunded"].intValue;
        self.qty_Shipped = data["qty"]["Shipped"].stringValue;
        self.qty_ShippedValue = data["qty"]["Shipped"].intValue;
        self.options = data["option"].arrayValue
    }
    
}


class CustomerOrderDetailsViewModel{
    var customerOrderList = [CustomerItemsData]()
    var customerTotalData = [CustomerTotal]()
    
    var customerOrderDetailsModel:CustomerOrderDetailsModel!
    
    init(data:JSON) {
        let arrayData = data["orderData"]["itemList"].arrayObject! as NSArray
        customerOrderList =  arrayData.map({(value) -> CustomerItemsData in
            return  CustomerItemsData(data:JSON(value))
        })
        
        let arrayData1 = data["orderData"]["totals"].arrayObject! as NSArray
        customerTotalData =  arrayData1.map({(value) -> CustomerTotal in
            return  CustomerTotal(data:JSON(value))
        })
        
        
        
        customerOrderDetailsModel = CustomerOrderDetailsModel(data: data)
    }
    
    
    
    
}








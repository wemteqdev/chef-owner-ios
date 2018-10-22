//
//  Chef_MyOrdersModel.swift
//  MobikulMPMagento2
//
//  Created by Othello on 19/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_MyOrdersModel: NSObject {
    var orderId:String = ""
    var id:String = ""
    var order_total:String = ""
    var order_Date:String = ""
    var ship_To:String = ""
    var status:String = ""
    var canReorder:Bool!
    var customerName:String = ""
    var supplierName: String = ""
    var restaurant: String = ""
    var supplierId: String = ""
    
    
    init(data: JSON) {
        self.orderId = data["orderId"].stringValue
        self.id = data["incrementId"].stringValue
        self.order_total = data["customerDetails"]["purchaseTotal"].stringValue
        self.customerName = data["customerDetails"]["name"].stringValue
        self.restaurant = data["customerDetails"]["restaurant"].stringValue
        self.supplierId = data["supplierId"].stringValue
        //self.ship_To = data["ship_to"].stringValue
        self.status = data["status"].stringValue
        self.supplierName = data["supplierName"].stringValue
        self.supplierId = data["supplierId"].stringValue
        self.order_Date = data["customerDetails"]["date"].stringValue
        self.canReorder = data["canReorder"].boolValue
        self.customerName = data["customerDetails"]["name"].stringValue
    }
    
    
}


class Chef_MyOrdersCollectionViewModel {
    var myOrderCollectionModel = [Chef_MyOrdersModel]()
    var orderStatus = [OrderStatus]()
    var totalCount:Int = 0
   // var extra:Extra!
    init(data:JSON) {
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            myOrderCollectionModel.append(Chef_MyOrdersModel(data: dict))
        }
        if let arrayData = data["orderStatus"].arrayObject{
            orderStatus =  arrayData.map({(value) -> OrderStatus in
                return  OrderStatus(data:JSON(value))
            })
        }
        //extra = Extra(data: data)
        totalCount = data["totalCount"].intValue
    }
    
    var getMyOrdersCollectionData:Array<Chef_MyOrdersModel>{
        return myOrderCollectionModel
    }
    
    
    
    func setMyOrderCollectionData(data:JSON){
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            myOrderCollectionModel.append(Chef_MyOrdersModel(data: dict))
        }
    }
    
    
}

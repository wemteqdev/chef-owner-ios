//
//  MyOrdersModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 22/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class MyOrdersModel: NSObject {
    
    var orderId:String = ""
    var id:String = ""
    var order_total:String = ""
    var order_Date:String = ""
    var ship_To:String = ""
    var status:String = ""
    var canReorder:Bool!
    
    
    
    init(data: JSON) {
        self.orderId = data["order_id"].stringValue
        self.id = data["id"].stringValue
        self.order_total = data["order_total"].stringValue
        self.ship_To = data["ship_to"].stringValue
        self.status = data["status"].stringValue
        self.order_Date = data["date"].stringValue
        self.canReorder = data["canReorder"].boolValue
    }


}

class Extra:NSObject{
    var totalCount:Int = 0
    
    init(data: JSON) {
        totalCount = data["totalCount"].intValue
    }
}

class MyOrdersCollectionViewModel {
    var myOrderCollectionModel = [MyOrdersModel]()
    var extra:Extra!
    init(data:JSON) {
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            myOrderCollectionModel.append(MyOrdersModel(data: dict))
        }
        extra = Extra(data: data)
    }

    var getMyOrdersCollectionData:Array<MyOrdersModel>{
        return myOrderCollectionModel
    }
 
    var totalCount:Int{
        return extra.totalCount
    }

    func setMyOrderCollectionData(data:JSON){
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            myOrderCollectionModel.append(MyOrdersModel(data: dict))
        }
    }
    

}




//
//  MyProductListModel.swift
//  ShangMarket
//
//  Created by kunal on 27/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation


struct MyProductListModel{
    var image:String = ""
    var earnedAmount:String = ""
    var name:String = ""
    var openable:Int = 0
    var productId:String = ""
    var price:String = ""
    var type:String = ""
    var qtyConfirmed:String = ""
    var qtypending:String = ""
    var qtySold:String = ""
    var status:String = ""
    
    init(data:JSON) {
        self.image = data["image"].stringValue
        self.name = data["name"].stringValue
        self.openable = data["openable"].intValue
        self.productId = data["productId"].stringValue
        self.price = data["productPrice"].stringValue
        self.type = data["productType"].stringValue
        self.qtyConfirmed = data["qtyConfirmed"].stringValue
        self.qtypending = data["qtyPending"].stringValue
        self.qtySold = data["qtySold"].stringValue
        self.status = data["status"].stringValue
        self.earnedAmount = data["earnedAmount"].stringValue
    }
}

class MyProductListViewModel: NSObject {
    
    var myProductListModel = [MyProductListModel]()
    var totalCount:Int = 0
    var disabledStatusText: String = ""
    var enabledStatusText: String = ""
    init(data:JSON) {
        if let arrayData = data["productList"].arrayObject{
            myProductListModel =  arrayData.map({(value) -> MyProductListModel in
                return  MyProductListModel(data:JSON(value))
            })
        }
        
        totalCount = data["totalCount"].intValue
        
        disabledStatusText = data["disabledStatusText"].stringValue
        enabledStatusText = data["enabledStatusText"].stringValue
    }
    
    
    func setProductCollectionData(data:JSON){
        let arrayData = data["productList"].arrayObject! as NSArray
        myProductListModel = myProductListModel + arrayData.map({(value) -> MyProductListModel in
            return  MyProductListModel(data:JSON(value))
        })
    }
}

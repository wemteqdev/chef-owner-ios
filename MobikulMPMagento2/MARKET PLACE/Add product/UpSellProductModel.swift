//
//  UpSellProductModel.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation



//
//  AddRelatedProductModel.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation


struct UPsellProductModel{
    var attrinuteSet:String!
    var entity_id:String!
    var name:String!
    var price:String!
    var selected:Int!
    var sku:String!
    var status:String!
    var thumbnail:String!
    var type:String!
    
    
    init(data:JSON) {
        self.attrinuteSet = data["attrinuteSet"].stringValue
        self.entity_id = data["entity_id"].stringValue
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.selected = data["selected"].intValue
        self.sku = data["sku"].stringValue
        self.status = data["status"].stringValue
        self.thumbnail = data["thumbnail"].stringValue
        self.type = data["type"].stringValue
        
    }
    
    
    
    
}



class UPsellProductViewModel{
    var upsellProductModel = [UPsellProductModel]()
    var totalCount:Int = 0
    
    init(data:JSON) {
        if let arrayData = data["productCollectionData"].arrayObject{
            upsellProductModel =  arrayData.map({(value) -> UPsellProductModel in
                return  UPsellProductModel(data:JSON(value))
            })
        }
        
        totalCount = data["totalCount"].intValue
        
    }
    
    func setProductCollectionData(data:JSON){
        let arrayData = data["productCollectionData"].arrayObject! as NSArray
        upsellProductModel = upsellProductModel + arrayData.map({(value) -> UPsellProductModel in
            return  UPsellProductModel(data:JSON(value))
        })
    }
    
    func setDataToRelatedModel(data:Int,pos:Int){
        upsellProductModel[pos].selected = data;
    }
    
    
    
}








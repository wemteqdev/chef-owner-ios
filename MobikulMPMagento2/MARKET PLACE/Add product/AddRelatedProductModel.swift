//
//  AddRelatedProductModel.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation


struct RelatedProductModel{
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



class RelatedProductViewModel{
var relatedProductModel = [RelatedProductModel]()
var totalCount:Int = 0
    
    init(data:JSON) {
    if let arrayData = data["productCollectionData"].arrayObject{
        relatedProductModel =  arrayData.map({(value) -> RelatedProductModel in
            return  RelatedProductModel(data:JSON(value))
        })
    }
        
     totalCount = data["totalCount"].intValue
        
    }
    
    func setProductCollectionData(data:JSON){
        let arrayData = data["productCollectionData"].arrayObject! as NSArray
        relatedProductModel = relatedProductModel + arrayData.map({(value) -> RelatedProductModel in
            return  RelatedProductModel(data:JSON(value))
        })
    }
    
    func setDataToRelatedModel(data:Int,pos:Int){
        relatedProductModel[pos].selected = data;
    }
    
 
    
}








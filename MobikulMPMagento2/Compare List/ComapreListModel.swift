//
//  ComapreListModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 25/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ComapreListModel: NSObject {
    var productName:String!
    var price:String!
    var imageUrl:String!
    var specialPrice:String!
    var rating:CGFloat!
    var productId:String!
    var hasOption:Int = 0
    var isInWishlist:Bool!
    var supplierName:String!
    var taxClass:String!
    var reviewCount:String!
    var cartId:String!
    var checked:Bool = false
    var qty:String = "0"
    var unit:String = ""
    var tierPrice:Double!
    var moq:Int!
    init(data:JSON){
        self.productName = data["name"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.specialPrice = data["finalPrice"].stringValue
        self.rating = CGFloat(data["rating"].doubleValue)
        self.imageUrl = data["thumbNail"].stringValue
        self.productId = data["entityId"].stringValue
        self.hasOption = data["hasOptions"].intValue
        self.isInWishlist = data["isInWishlist"].boolValue
        self.reviewCount = data["reviewcount"].stringValue
        self.taxClass = data["tax_class"].stringValue
        self.supplierName = data["suppliername"].stringValue
        self.tierPrice = data["tierPrice"].doubleValue
        if self.tierPrice == nil {
            self.tierPrice = 0
        }
        self.moq = data["moq"].intValue
        if self.moq == nil {
            self.moq = 0
        }
        self.unit = data["unitString"].stringValue
        
     }
    


}

class AttributesName:NSObject{
    var attributesName:String!
    init(data:JSON){
        self.attributesName = data["attributeName"].stringValue
    }

}



class AttributesValue: NSObject {
    var attributesValueArray:Array<Any>!
    
    init(data:JSON){
        self.attributesValueArray = data["value"].arrayObject

    }

    
}


class CompareListViewModel:NSObject{
    var productListModel = [ComapreListModel]()
    var attributesName = [AttributesName]()
    var attributesValue = [AttributesValue]()
    
    
    init(data:JSON) {
        let arrayData = data["productList"].arrayObject! as NSArray
        productListModel =  arrayData.map({(value) -> ComapreListModel in
            return  ComapreListModel(data:JSON(value))
        })
    
        let arrayData2 = data["attributeValueList"].arrayObject! as NSArray
        attributesName =  arrayData2.map({(value) -> AttributesName in
            return  AttributesName(data:JSON(value))
        })
        
        let arrayData3 = data["attributeValueList"].arrayObject! as NSArray
        attributesValue =  arrayData3.map({(value) -> AttributesValue in
            return  AttributesValue(data:JSON(value))
        })
        
    }
    
    var getProductList:Array<ComapreListModel>{
        return productListModel
    }
    
    var getAttributsName:Array<AttributesName>{
        return attributesName
    }
    
    var getAttributesValue:Array<AttributesValue>{
        return attributesValue
    }
    func setCheck(checked:Bool,pos:Int){
        productListModel[pos].checked = checked
    }
    func setQty(qty:String,pos:Int){
        productListModel[pos].qty = qty
    }
}





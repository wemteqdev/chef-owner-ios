//
//  SearchSuggestionModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul Parsad on 10/08/17.
//  Copyright © 2017 Webkul Parsad. All rights reserved.
//

import UIKit

class SearchSuggestionModel: NSObject {
    
    var productName:String = ""
    var productImage:String = ""
    var id:String = ""
    var price:String = ""
    var hasSpecialPrice: Bool = false
    var specialPrice : String = ""
    
    init(data: JSON) {
        self.productImage = data["thumbNail"].stringValue
        self.id = data["productId"].stringValue
        self.price = data["price"].stringValue
        self.productName = data["productName"].stringValue.html2String
        self.hasSpecialPrice = data["hasSpecialPrice"].boolValue
        self.specialPrice = data["specialPrice"].stringValue.html2String
    }
    
}

class SearchsuggestionHints:NSObject{
    var label:String = ""
    var countValue:Int = 0
    init(data: JSON) {
        self.label = data["label"].stringValue.html2String
        self.countValue = data["count"].intValue
    }
    
    
    
}

class SearchSuggestionViewModel:NSObject{
    var searchSuggestionModel = [SearchSuggestionModel]()
    var searchSuggestionHintsModel = [SearchsuggestionHints]();
    
    
    init(data:JSON) {
        for i in 0..<data["suggestProductArray"]["products"].count{
            let dict = data["suggestProductArray"]["products"][i];
            searchSuggestionModel.append(SearchSuggestionModel(data: dict))
        }
        for i in 0..<data["suggestProductArray"]["tags"].count{
            let dict = data["suggestProductArray"]["tags"][i];
            searchSuggestionHintsModel.append(SearchsuggestionHints(data: dict))
        }
        
    }
    
    var getSuggestedproduct:Array<SearchSuggestionModel>{
        return searchSuggestionModel
    }
    var getSuggestedHints:Array<SearchsuggestionHints>{
        return searchSuggestionHintsModel
    }
    
    
    
    
}





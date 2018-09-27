//
//  SearchTermsModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 24/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class SearchTermsModel: NSObject {
    var term:String!
    init(data:JSON) {
        self.term = data["term"].stringValue
    }
}


class SearchTermViewModel:NSObject{
    var searchTermsModel = [SearchTermsModel]()
    
    init(data:JSON) {
        let arrayData = data["termList"].arrayObject! as NSArray
        searchTermsModel =  arrayData.map({(value) -> SearchTermsModel in
            return  SearchTermsModel(data:JSON(value))
        })
    }
    
    var getSearchterms:Array<SearchTermsModel>{
        return searchTermsModel
    }
    
}

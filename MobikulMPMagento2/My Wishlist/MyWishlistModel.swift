//
//  MyWishlistModel.swift
//  MobikulMagento-2
//
//  Created by himanshu on 14/08/18.
//  Copyright © 2018 Webkul. All rights reserved.
//


import UIKit

struct MyWishlistModel  {
    
    var description: String = ""
    var id: String = ""
    var name: String = ""
    var price: String = ""
    var productId: String = ""
    var qty: Int = 0
    var rating: Double = 0.0
    var sku: String = ""
    var thumbNail: String = ""
    var typeId: String = ""
    var options : NSArray!

    init(data: JSON) {
        description = data["description"].stringValue
        id = data["id"].stringValue
        name = data["name"].stringValue
        price = data["price"].stringValue
        productId = data["productId"].stringValue
        qty = data["qty"].intValue
        rating = data["rating"].doubleValue
        sku = data["sku"].stringValue
        thumbNail = data["thumbNail"].stringValue
        typeId = data["typeId"].stringValue
        options = data["options"].arrayObject! as NSArray
    }
}

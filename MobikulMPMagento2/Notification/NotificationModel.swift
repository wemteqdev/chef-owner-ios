//
//  NotificationModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 04/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class NotificationModel: NSObject {
    var bannerImage:String = ""
    var contet:String = ""
    var id:String = ""
    var notificationType:String = ""
    var title:String = ""
    var productName:String = ""
    var categoryId:String = ""
    var categoryName : String = ""
    
    init(data: JSON) {
        self.bannerImage = data["banner"].stringValue
        self.contet = data["content"].stringValue
        self.id = data["id"].stringValue
        self.notificationType = data["notificationType"].stringValue
        self.title = data["title"].stringValue
        self.productName = data["productName"].stringValue
        self.categoryId = data["categoryId"].stringValue
        self.categoryName = data["categoryName"].stringValue
    }
}

class NotificationViewModel {
    
    var notificationModel = [NotificationModel]()
    init(data:JSON) {
        for i in 0..<data["notificationList"].count{
            let dict = data["notificationList"][i];
            notificationModel.append(NotificationModel(data: dict))
        }
    }
    
    
    


}

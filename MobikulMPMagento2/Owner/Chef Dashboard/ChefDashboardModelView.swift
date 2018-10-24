//
//  ChefDashboardModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 10/3/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class ChefDashboardModelView: NSObject {
    var chefInfos = [ChefInfoModel]();
    var chefEmails = [String]();
    init(data:JSON) {
        //-------------Get Chef Info--------------------------
        if let chefArrayData = data["chefsInfo"].arrayObject{
            chefInfos =  chefArrayData.map({(value) -> ChefInfoModel in
                return  ChefInfoModel(data:JSON(value))
            })
        }
        print("chefCount:" + String(format: "%d", chefInfos.count));
        if let emailsArrayData = data["chefsEmail"].arrayObject{
            chefEmails = emailsArrayData as! [String];
            print("chefEmails:", emailsArrayData as! [String]);
        }
    }
}

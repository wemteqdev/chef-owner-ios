//
//  SuppliersModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 10/7/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

struct SupplierInfoModel {
    var supplierId:Int!
    var email:String!
    var supplierName:String!
    var status:Int!
    var address:String!
    var customerImage:String!
    
    init(data:JSON) {
        supplierId = data["customerInfo"]["entity_id"].intValue;
        email = data["customerInfo"]["email"].stringValue;
        supplierName = data["customerInfo"]["firstname"].stringValue + " " + data["customerInfo"]["lastname"].stringValue;
        status = data["status"].intValue;
        address = data["address"]["street"].stringValue + "," + data["address"]["city"].stringValue;
        customerImage = data["profileImage"].stringValue;
    }
}

class AddSupplierInfoModel: NSObject {
    var isAddSuccess: Bool = false;
    var errorMessage: String = "";
    var supplierInfo: SupplierInfoModel!;
    
    init(data:JSON) {
        isAddSuccess = data["addSupplierSuccess"].boolValue;
        errorMessage = data["errorMessage"].stringValue;
        supplierInfo = SupplierInfoModel(data:data["supplierInfo"]);
    }
}

class SuppliersViewModel: NSObject {
    var suppliersInfo = [SupplierInfoModel]();
    
    init(data:JSON){
        //----------Get Graph Data(For daily, weekly, monthly, yearly)--------------
        if let arrayData = data["customersInfo"].arrayObject{
            suppliersInfo =  arrayData.map({(value) -> SupplierInfoModel in
                return  SupplierInfoModel(data:JSON(value))
            })
        }
    }
}

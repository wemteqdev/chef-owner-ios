//
//  CreateAttributeModel.swift
//  ShangMarket
//
//  Created by kunal on 03/04/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation



struct TopCreateDataModdel{
    var attributeCode:String = ""
    var attributeLabel:String = ""
    var valueRequired:String = ""
    
    init() {
        attributeCode = ""
        attributeLabel = ""
        valueRequired = "0"
    }
    
}


struct BottonCreateAttributeData{
    var admin:String = ""
    var defaultStoreViewData:String = ""
    var position:String = ""
    var isDefault:String = ""
    
    init() {
        self.admin = ""
        self.defaultStoreViewData = ""
        self.position = ""
        self.isDefault = "off"
    }
    
    
}






class CreateAttributeViewModel: NSObject {
    var topCreateDataModdel:TopCreateDataModdel!
    var bottonCreateAttributeData = [BottonCreateAttributeData]()
    
    
    
    init(data:String) {
       topCreateDataModdel = TopCreateDataModdel()
       bottonCreateAttributeData.append(BottonCreateAttributeData())
    }
    
    
    func setNewBottomAttributeData(){
        bottonCreateAttributeData.append(BottonCreateAttributeData())
    }
    
    func removeNewBottomAttributeData(pos:Int){
        bottonCreateAttributeData.remove(at: pos)
    }
    
    func setBottomCreateAdminValue(pos:Int,Value:String){
        bottonCreateAttributeData[pos].admin = Value
    }
    
    func setBottomCreateStoreValue(pos:Int,Value:String){
        bottonCreateAttributeData[pos].defaultStoreViewData = Value
    }
    
    func setBottomCreatePositionValue(pos:Int,Value:String){
        bottonCreateAttributeData[pos].position = Value
    }
    
    func setBottomCreateIsdefaultValue(pos:Int,Value:String){
        bottonCreateAttributeData[pos].isDefault = Value
    }

    
    
    
    
    func setAttributeCodeValue(value:String){
        topCreateDataModdel.attributeCode = value
    }
    
    func setAttributeLabelValue(value:String){
        topCreateDataModdel.attributeLabel = value
    }
    
    func setValueRequired(value:String){
        topCreateDataModdel.valueRequired = value
        
    }
    
}


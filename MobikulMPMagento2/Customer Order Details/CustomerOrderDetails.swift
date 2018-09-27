//
//  CustomerOrderDetails.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 23/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CustomerOrderDetails: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let defaults = UserDefaults.standard;
    var incrementId:String!
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
    @IBOutlet weak var tableView: UITableView!
    var dynamicCellHeight:CGFloat = 0
    var dynamicSummaryHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        tableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        tableView.register(UINib(nibName: "OrderInfoItemList", bundle: nil), forCellReuseIdentifier: "OrderInfoItemList")
        tableView.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
        tableView.register(UINib(nibName: "StatusOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusOrderTableViewCell")
        
        
        self.tableView.estimatedRowHeight = 250.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        
        
        callingHttppApi();
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "orderdetails")
        
    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        if self.defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
        }
        requstParams["incrementId"] = incrementId
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/orderDetails", currentView: self){success,responseObject in
            if success == 1{
                
                print(responseObject)
                GlobalData.sharedInstance.dismissLoader()
                self.customerOrderDetailsModel =  CustomerOrderDetailsViewModel(data: JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingwithresult();
            }else if success == 2{
                self.callingHttppApi()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
        
    }
    
    
    
    
    func doFurtherProcessingwithresult(){
        print("sss",self.customerOrderDetailsModel.customerTotalData[0].label )
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.reloadData()
        
    }
    
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return 7;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1;
        }
        else if section == 1{
            if customerOrderDetailsModel.customerOrderDetailsModel.billingAddress != ""{
                return 1;
            }else{
                return 0;
            }
        }else if section == 2{
            if customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod != ""{
                return 1;
            }else{
                return 0;
            }
        }else if section == 3{
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingAddress != ""{
                return 1;
            }else{
                return 0;
            }
        }else if section == 4{
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingMethod != ""{
                return 1;
            }else{
                return 0;
            }
        }else if section == 5{
            return customerOrderDetailsModel.customerOrderList.count
        }else if section == 6{
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 6{
            return dynamicSummaryHeight + 50
        } else{
            return UITableViewAutomaticDimension;
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:StatusOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StatusOrderTableViewCell") as! StatusOrderTableViewCell
            cell.placeOnDateValue.text = customerOrderDetailsModel.customerOrderDetailsModel.orderDate
            cell.statusMessage.text = " "+customerOrderDetailsModel.customerOrderDetailsModel.status+" "
            if customerOrderDetailsModel.customerOrderDetailsModel.status.lowercased() == "pending"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: ORANGECOLOR)
            }else if customerOrderDetailsModel.customerOrderDetailsModel.status.lowercased() == "complete"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
            }else if customerOrderDetailsModel.customerOrderDetailsModel.status.lowercased() == "processing"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
            }else if customerOrderDetailsModel.customerOrderDetailsModel.status.lowercased() == "cancel"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR)
            }
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.billingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.shippingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 4 {
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.shippingMethod
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 5 {
            let cell:OrderInfoItemList = tableView.dequeueReusableCell(withIdentifier: "OrderInfoItemList") as! OrderInfoItemList
            cell.productName.text = customerOrderDetailsModel.customerOrderList[indexPath.row].productName.html2String
            cell.priceValue.text = customerOrderDetailsModel.customerOrderList[indexPath.row].price
            cell.subtotalValue.text = customerOrderDetailsModel.customerOrderList[indexPath.row].SubTotal
            var qtyValue = ""
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_CanceledValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "canceled")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Canceled+"\n"
            }
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_OrderedValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "ordered")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Ordered+"\n"
            }
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_RefundedValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "refunded")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Refunded+"\n"
            }
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_ShippedValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "shipped")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Shipped+"\n"
            }
            cell.qtyValue.text = qtyValue
            
            
            
            var optionDict = customerOrderDetailsModel.customerOrderList[indexPath.row].options
            
            
            var stringData = ""
            var finalData = ""
            
            
            
            if (optionDict.count) > 0 {
                
                for j in 0..<(optionDict.count){
                    var dict = optionDict[j];
                    stringData  = stringData+(dict["label"].stringValue)+": "+(dict["value"].stringValue)+"\n"
                }
                
                finalData = GlobalData.sharedInstance.language(key: "options")+"\n"+stringData
            }
            
            cell.productValue.text = finalData
            
            cell.selectionStyle = .none
            return cell
            
            
        }else {
            let cell:OrderSummaryCell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell") as! OrderSummaryCell
            var Y:CGFloat = 0;
            
            for subViews: UIView in cell.dynamicView.subviews {
                subViews.removeFromSuperview()
            }
            
            
            for i in 0..<customerOrderDetailsModel.customerTotalData.count{
                let optionLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(cell.dynamicView.frame.size.width - 10), height: CGFloat(20)))
                optionLabel.textColor = UIColor.black
                optionLabel.font = UIFont(name: BOLDFONT, size: CGFloat(16))!
                optionLabel.text = customerOrderDetailsModel.customerTotalData[i].label
                cell.dynamicView.addSubview(optionLabel)
                
                Y += 20;
                
                let optionValue = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(cell.dynamicView.frame.size.width - 10), height: CGFloat(20)))
                optionValue.textColor = UIColor.darkGray
                optionValue.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                optionValue.text = customerOrderDetailsModel.customerTotalData[i].value
                cell.dynamicView.addSubview(optionValue)
                
                Y += 20;
            }
            
            cell.dynamicViewHeightConstarints.constant = Y
            dynamicSummaryHeight = Y
            
            cell.selectionStyle = .none
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "#"+self.incrementId
        }
        else if(section == 1){
            if customerOrderDetailsModel.customerOrderDetailsModel.billingAddress != ""{
                return "  "+GlobalData.sharedInstance.language(key:"billingaddress");
            }else{
                return ""
            }
        }else if(section == 2){
            if customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod != ""{
                return "  "+GlobalData.sharedInstance.language(key:"billingmethod");
            }else{
                return ""
            }
        }else if(section == 3){
            return "  "+GlobalData.sharedInstance.language(key:"shippingaddress");
        }else if(section == 4){
            return "  "+GlobalData.sharedInstance.language(key:"shipmentmethod");
        }else if(section == 5){
            return "  "+GlobalData.sharedInstance.language(key:"itemlist");
        }else if(section == 6){
            return "  "+GlobalData.sharedInstance.language(key:"ordersummary");
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1){
            if customerOrderDetailsModel.customerOrderDetailsModel.billingAddress != ""{
                return 30;
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else if(section == 2){
            if customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod != ""{
                return 30
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else if(section == 3){
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingAddress != ""{
                return 30
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else if(section == 4){
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingMethod != ""{
                return 30
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else if section == 5{
            return 30
        }
        else{
            return CGFloat.leastNonzeroMagnitude
        }
        
        
    }
    
    
    
    
    
    
    
    
}

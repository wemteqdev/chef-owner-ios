//
//  ShipmentDetailsController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

@objc protocol ShippingTrackingDelegate: class {
    func getShippingTrackingInfo(pos:Int,title:String,numberValue:String)
    
}



import UIKit

class ShipmentDetailsController: UIViewController,UITableViewDelegate, UITableViewDataSource,ShippingTrackingDelegate{
@IBOutlet weak var tableView: UITableView!
    
var whichApiToProcess:String = ""
var incrementId:String = ""
var shipmentid:String = ""
var sellerShipmentDetailsViewModel:SellerShipmentDetailsViewModel!
var trackingId:String = ""
var currentCarrierNumber:Int = 0
var titleValue:String!
var numberValue:String!
var documentPathUrl:NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "shipmentdetails")
        tableView.register(UINib(nibName: "SellerOrderDetailsTopCell", bundle: nil), forCellReuseIdentifier: "SellerOrderDetailsTopCell")
        tableView.register(UINib(nibName: "SellerItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerItemsTableViewCell")
        tableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        tableView.register(UINib(nibName: "TrackingInformationCell", bundle: nil), forCellReuseIdentifier: "TrackingInformationCell")
        tableView.register(UINib(nibName: "AddTrackingInfoCell", bundle: nil), forCellReuseIdentifier: "AddTrackingInfoCell")
        tableView.register(UINib(nibName: "SellerOrderDetailsTotalCell", bundle: nil), forCellReuseIdentifier: "SellerOrderDetailsTotalCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        currentCarrierNumber = 0
        
        callingHttppApi()

    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        requstParams["incrementId"] = incrementId
        requstParams["shipmentId"] = shipmentid
        
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "sendtrackinginfo"{
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/sendTrackinginfo", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                    print("dsd", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if whichApiToProcess == "addtrackinginfo"{
            requstParams["carrier"] = self.sellerShipmentDetailsViewModel.trackingCarrier[currentCarrierNumber].value
            requstParams["title"] = titleValue
            requstParams["number"] = numberValue
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/addtrackinginfo", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                    print("dsd", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        
        
        else if whichApiToProcess == "deletetrackinginfo"{
            requstParams["trackId"] = trackingId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/deleteTrackinginfo", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                    print("dsd", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        else{
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/viewshipment", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.sellerShipmentDetailsViewModel = SellerShipmentDetailsViewModel(data:dict)
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                    print("dsd", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    

    
    
    @IBAction func printClick(_ sender: Any) {
        let customerId = defaults.object(forKey:"customerId") as! String;
        let storeId = defaults.object(forKey: "storeId") as! String;
        let url = HOST_NAME+"/mobikulmphttp/marketplace/PrintShipment/storeId/"+storeId+"/customerToken/"+customerId+"/incrementId/"+incrementId+"/shipmentId/"+shipmentid
        
        var fileName:String = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        fileName = "Shipment"+shipmentid+formatter.string(from: date)+".pdf"
        
        self.load(url: URL(string: url)!, params: "",name: fileName)
        GlobalData.sharedInstance.showLoader()
        
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 1{
            return self.sellerShipmentDetailsViewModel.sellerOrderItemList.count
        }else if section == 4{
            if self.sellerShipmentDetailsViewModel.shippingAddress == ""{
                return 0
            }else{
                return 1
            }
        }else if section == 6{
            if self.sellerShipmentDetailsViewModel.shippingMethod == ""{
                return 0
            }else{
                return 1
            }
        }else if section == 7{
              return self.sellerShipmentDetailsViewModel.trackingCarrierDetails.count
        }
        
        
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrderDetailsTopCell", for: indexPath) as! SellerOrderDetailsTopCell
            cell.mailHeight.constant = 40;
            cell.sendMailButton.isHidden = false
            cell.viewInvoice.isHidden = true
            cell.viewshipment.isHidden = true
            cell.viewRefunds.isHidden = true
            cell.sendMailButton.setTitle(GlobalData.sharedInstance.language(key: "sendtrackinginfo"), for: .normal)
            cell.sendMailButton.addTarget(self, action: #selector(sendtrackingInfo(sender:)), for: .touchUpInside)
            cell.sendMailButton.isUserInteractionEnabled = true;
            
            cell.selectionStyle = .none
            return cell
            
        }else  if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerItemsTableViewCell", for: indexPath) as! SellerItemsTableViewCell
            cell.productName.text = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].productName
            cell.priceLabelValue.text = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].price
            cell.totalLabelValue.text = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].totalPrice
            cell.admincommissionLabelValue.text = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].adminCommission
            cell.vendorTotalLabelValue.text = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].vendorTotal
            cell.subtotalLabelValue.text = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].subtotal
            
            
            var optionData:String = ""
            for i in 0..<self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].sellerQty.count{
                let first = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].sellerQty[i].label
                let second = self.sellerShipmentDetailsViewModel.sellerOrderItemList[indexPath.row].sellerQty[i].value
                optionData = optionData+first!+":"+second!+"\n"
            }
            
            cell.qtyLabelValue.text = optionData
            cell.selectionStyle = .none
            return cell
            
            
        }else  if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrderDetailsTotalCell", for: indexPath) as! SellerOrderDetailsTotalCell
            cell.subtaotalLabelValue.text = self.sellerShipmentDetailsViewModel.subTotal
            cell.shipping_handlingLabelValue.text = self.sellerShipmentDetailsViewModel.shipping
            cell.discountLabelValue.text = self.sellerShipmentDetailsViewModel.discount
            cell.totalTaxValue.text = self.sellerShipmentDetailsViewModel.tax
            cell.totalOrderAmountLabelValue.text = self.sellerShipmentDetailsViewModel.orderTotal
            cell.totalVendorAmountLabelValue.text = self.sellerShipmentDetailsViewModel.vendorTotal
            cell.totalAdminCommissionLabelValue.text = self.sellerShipmentDetailsViewModel.adminCommission
            cell.selectionStyle = .none
            return cell
        }
        
        
        
        else  if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerShipmentDetailsViewModel.billingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 4{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerShipmentDetailsViewModel.shippingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 5{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerShipmentDetailsViewModel.paymentMethod
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 6{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerShipmentDetailsViewModel.shippingMethod
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 7{
            let cell:TrackingInformationCell = tableView.dequeueReusableCell(withIdentifier: "TrackingInformationCell") as! TrackingInformationCell
            cell.carrierLabelValue.text = self.sellerShipmentDetailsViewModel.trackingCarrierDetails[indexPath.row].carrier
            cell.titleLabelValue.text = self.sellerShipmentDetailsViewModel.trackingCarrierDetails[indexPath.row].title
            cell.numberValue.text = self.sellerShipmentDetailsViewModel.trackingCarrierDetails[indexPath.row].trackingNumber
            
            cell.crossButton.addTarget(self, action: #selector(deleteTracking(sender:)), for: .touchUpInside)
            cell.crossButton.isUserInteractionEnabled = true;
            cell.crossButton.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:AddTrackingInfoCell = tableView.dequeueReusableCell(withIdentifier: "AddTrackingInfoCell") as! AddTrackingInfoCell
            cell.sellerShipmentDetailsViewModel = self.sellerShipmentDetailsViewModel
            if self.sellerShipmentDetailsViewModel.trackingCarrier.count > 0{
                cell.carrierField.text = self.sellerShipmentDetailsViewModel.trackingCarrier[currentCarrierNumber].label
            }
            cell.currentCarrierNumber = self.currentCarrierNumber
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return GlobalData.sharedInstance.language(key: "itemlist");
        }else if section == 4{
            if self.sellerShipmentDetailsViewModel.shippingAddress == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shippingaddress")
            }
        }else if section == 3{
            return GlobalData.sharedInstance.language(key:"billingaddress");
        }else if section == 5{
            return GlobalData.sharedInstance.language(key:"billingmethod");
        }else if section == 6{
            if self.sellerShipmentDetailsViewModel.shippingMethod == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shipmentmethod")
            }
        }
            
        else{
            return ""
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNonzeroMagnitude
        }else{
            return 30
        }
    }
    
    
    
    func getShippingTrackingInfo(pos:Int,title:String,numberValue:String){
        whichApiToProcess = "addtrackinginfo";
        currentCarrierNumber  = pos
        self.titleValue = title
        self.numberValue = numberValue
        callingHttppApi()
        
    }
    
    
    
    @objc func sendtrackingInfo(sender: UIButton){
        whichApiToProcess = "sendtrackinginfo"
        callingHttppApi()
        
    }
    
    
    
    @objc func deleteTracking(sender: UIButton){
        trackingId = self.sellerShipmentDetailsViewModel.trackingCarrierDetails[sender.tag].id
        whichApiToProcess = "deletetrackinginfo"
        callingHttppApi()
      
    }
    
    func load(url: URL, params:String, name:String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .post)
     
    
        
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                    GlobalData.sharedInstance.dismissLoader()
                    
                    
                }
                do{
                    let largeImageData = try Data(contentsOf: tempLocalUrl)
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(name);
                    
                    
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try largeImageData.write(to: fileURL)
                            let AC = UIAlertController(title:GlobalData.sharedInstance.language(key: "success"), message:GlobalData.sharedInstance.language(key: "filesavemessage"), preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "view", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.documentPathUrl = fileURL as NSURL;
                                self.performSegue(withIdentifier: "showFileData", sender: self)
                                
                            })
                            let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            AC.addAction(noBtn)
                            self.present(AC, animated: true, completion: { })
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        print("Image Not Added")
                    }
                    
                    
                    
                    
                }catch{
                    print("error");
                }
                
                
                
                do {
                    
                } catch (let writeError) {
                    
                }
                
            } else {
                GlobalData.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "showFileData") {
            let viewController:ShowDownloadFile = segue.destination as UIViewController as! ShowDownloadFile
            viewController.documentUrl = documentPathUrl
        }
        
    }
    
    
    
   
}

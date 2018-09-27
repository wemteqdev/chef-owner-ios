//
//  SellerInvoiceDetailsController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerInvoiceDetailsController: UIViewController,UITableViewDelegate, UITableViewDataSource{
var invoiceId:String = ""
var incrementId:String = ""
var sellerInvoiceDetailsViewModel:SellerInvoiceDetailsViewModel!
@IBOutlet weak var tableView: UITableView!
var whichApiToProcess:String = ""
var documentPathUrl:NSURL!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "invoicedetails")
        
        tableView.register(UINib(nibName: "SellerOrderDetailsTopCell", bundle: nil), forCellReuseIdentifier: "SellerOrderDetailsTopCell")
        tableView.register(UINib(nibName: "SellerItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerItemsTableViewCell")
        tableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        tableView.register(UINib(nibName: "SellerShipmentTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerShipmentTableViewCell")
        tableView.register(UINib(nibName: "CustomerInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerInfoTableViewCell")
        tableView.register(UINib(nibName: "SellerOrderDetailsTotalCell", bundle: nil), forCellReuseIdentifier: "SellerOrderDetailsTotalCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        
        callingHttppApi()

    }

    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        requstParams["incrementId"] = incrementId
        requstParams["invoiceId"] = invoiceId
        
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "mail"{
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/SendInvoice", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                        
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
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/viewinvoice", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerInvoiceDetailsViewModel = SellerInvoiceDetailsViewModel(data:dict)
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
    
    
    
    
    
    @IBAction func printInvoiceClick(_ sender: Any) {
        let customerId = defaults.object(forKey:"customerId") as! String;
        let storeId = defaults.object(forKey: "storeId") as! String;
        let url = HOST_NAME+"/mobikulmphttp/marketplace/printInvoice/storeId/"+storeId+"/customerToken/"+customerId+"/incrementId/"+incrementId+"/invoiceId/"+invoiceId
        
        var fileName:String = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        fileName = "invoice"+invoiceId+formatter.string(from: date)+".pdf"
        
        self.load(url: URL(string: url)!, params: "",name: fileName)
        GlobalData.sharedInstance.showLoader()
        
      
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return self.sellerInvoiceDetailsViewModel.sellerOrderItemList.count
        }else if section == 3{
            if self.sellerInvoiceDetailsViewModel.shippingAddress == ""{
                return 0
            }else{
                return 1
            }
        }else if section == 5{
            if self.sellerInvoiceDetailsViewModel.shippingMethod == ""{
                return 0
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5{
            let cell:SellerShipmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SellerShipmentTableViewCell") as! SellerShipmentTableViewCell
            cell.shipmentValue.text = sellerInvoiceDetailsViewModel.shippingMethod
            if sellerInvoiceDetailsViewModel.shipmentId != "0"{
                cell.carriertextField.isHidden = true
                cell.trackingtextField.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
            
        }else  if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerItemsTableViewCell", for: indexPath) as! SellerItemsTableViewCell
            cell.productName.text = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].productName
            cell.priceLabelValue.text = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].price
            cell.totalLabelValue.text = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].totalPrice
            cell.admincommissionLabelValue.text = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].adminCommission
            cell.vendorTotalLabelValue.text = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].vendorTotal
            cell.subtotalLabelValue.text = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].subtotal
            
            
            var optionData:String = ""
            for i in 0..<self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].sellerQty.count{
                let first = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].sellerQty[i].label
                let second = self.sellerInvoiceDetailsViewModel.sellerOrderItemList[indexPath.row].sellerQty[i].value
                optionData = optionData+first!+":"+second!+"\n"
            }
            
            cell.qtyLabelValue.text = optionData
            cell.selectionStyle = .none
            return cell
        }else  if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrderDetailsTotalCell", for: indexPath) as! SellerOrderDetailsTotalCell
            cell.subtaotalLabelValue.text = self.sellerInvoiceDetailsViewModel.subTotal
            cell.shipping_handlingLabelValue.text = self.sellerInvoiceDetailsViewModel.shipping
            cell.discountLabelValue.text = self.sellerInvoiceDetailsViewModel.discount
            cell.totalTaxValue.text = self.sellerInvoiceDetailsViewModel.tax
            cell.totalOrderAmountLabelValue.text = self.sellerInvoiceDetailsViewModel.orderTotal
            cell.totalVendorAmountLabelValue.text = self.sellerInvoiceDetailsViewModel.vendorTotal
            cell.totalAdminCommissionLabelValue.text = self.sellerInvoiceDetailsViewModel.adminCommission
            cell.selectionStyle = .none
            return cell
        }else  if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerInvoiceDetailsViewModel.billingAddress
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerInvoiceDetailsViewModel.shippingAddress
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 4{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerInvoiceDetailsViewModel.paymentMethod
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrderDetailsTopCell", for: indexPath) as! SellerOrderDetailsTopCell
            cell.mailHeight.constant = 40;
            cell.sendMailButton.isHidden = false
            cell.viewInvoice.isHidden = true
            cell.viewshipment.isHidden = true
            cell.viewRefunds.isHidden = true
            
            cell.sendMailButton.addTarget(self, action: #selector(sendMail(sender:)), for: .touchUpInside)
            cell.sendMailButton.isUserInteractionEnabled = true;
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerInfoTableViewCell", for: indexPath) as! CustomerInfoTableViewCell
            cell.customerNameValue.text = self.sellerInvoiceDetailsViewModel.buyerName
            cell.emailValue.text = self.sellerInvoiceDetailsViewModel.buyerEmail
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return GlobalData.sharedInstance.language(key: "itemlist");
        }else if section == 3{
            if self.sellerInvoiceDetailsViewModel.shippingAddress == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shippingaddress")
            }
        }else if section == 2{
            return GlobalData.sharedInstance.language(key:"billingaddress");
        }else if section == 4{
            return GlobalData.sharedInstance.language(key:"billingmethod");
        }else if section == 5{
            if self.sellerInvoiceDetailsViewModel.shippingMethod == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shipmentmethod")
            }
        }else if section == 7{
            return GlobalData.sharedInstance.language(key:"buyerinformation")
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
    
    
    
    @objc func sendMail(sender: UIButton){
        whichApiToProcess = "mail";
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

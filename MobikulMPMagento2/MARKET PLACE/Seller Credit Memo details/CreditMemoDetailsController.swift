//
//  CreditMemoDetailsController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoDetailsController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    var incrementId:String!
    var creditMemoId:String!
    @IBOutlet weak var tableView: UITableView!
    var sellerCreditMemoDetailsViewModel:SellerCreditMemoDetailsViewModel!
    var documentPathUrl:NSURL!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "details")
        
        
        tableView.register(UINib(nibName: "CreditMemoProductItemListCell", bundle: nil), forCellReuseIdentifier: "CreditMemoProductItemListCell")
        tableView.register(UINib(nibName: "CreditMemoDetailsItemCell", bundle: nil), forCellReuseIdentifier: "CreditMemoDetailsItemCell")
        tableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        
        
        
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
        requstParams["creditmemoId"] = creditMemoId
        
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/viewCreditMemo", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerCreditMemoDetailsViewModel = SellerCreditMemoDetailsViewModel(data:dict)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return self.sellerCreditMemoDetailsViewModel.sellerOrderItemList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell:CreditMemoProductItemListCell = tableView.dequeueReusableCell(withIdentifier: "CreditMemoProductItemListCell") as! CreditMemoProductItemListCell
            cell.name.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].productName
            cell.priceLabelValue.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].price
            cell.qtyLabelValue.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].qty
            cell.subtotalLabelValue.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].subtotal
            cell.taxLabelValue.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].totalTax
            cell.discountLabelValue.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].discountTotal
            cell.rowtotalLabelValue.text = self.sellerCreditMemoDetailsViewModel.sellerOrderItemList[indexPath.row].subtotal
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            
            let cell:CreditMemoDetailsItemCell = tableView.dequeueReusableCell(withIdentifier: "CreditMemoDetailsItemCell") as! CreditMemoDetailsItemCell
            cell.subtotalLabelValue.text = self.sellerCreditMemoDetailsViewModel.subTotal
            cell.discountLabelValue.text = self.sellerCreditMemoDetailsViewModel.discount
            cell.totalTaxLabelValue.text = self.sellerCreditMemoDetailsViewModel.tax
            cell.shipping_handlingLabelValue.text = self.sellerCreditMemoDetailsViewModel.shipping
            cell.adjustmentRefundLabelValue.text = self.sellerCreditMemoDetailsViewModel.adjustmentAmt
            cell.adjustmentFeeLabelValue.text = self.sellerCreditMemoDetailsViewModel.adjustmentFee
            cell.grandTotalLabelValue.text = self.sellerCreditMemoDetailsViewModel.grandTotalAmount
            cell.selectionStyle = .none
            return cell
            
        }else  if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerCreditMemoDetailsViewModel.billingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerCreditMemoDetailsViewModel.shippingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 4{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerCreditMemoDetailsViewModel.paymentMethod
            cell.selectionStyle = .none
            return cell
        }else {
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerCreditMemoDetailsViewModel.shippingMethod
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return GlobalData.sharedInstance.language(key: "itemlist");
        }
        else if section == 3{
            if self.sellerCreditMemoDetailsViewModel.shippingAddress == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shippingaddress")
            }
        }else if section == 2{
            return GlobalData.sharedInstance.language(key:"billingaddress");
        }else if section == 4{
            return GlobalData.sharedInstance.language(key:"billingmethod");
        }else if section == 5{
            if self.sellerCreditMemoDetailsViewModel.shippingMethod == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shipmentmethod")
            }
        }else{
            return ""
        }
    }
    
    
    @IBAction func PrintClick(_ sender: Any) {
        let customerId = defaults.object(forKey:"customerId") as! String;
        let storeId = defaults.object(forKey: "storeId") as! String;
        let url = HOST_NAME+"mobikulmphttp/marketplace/printcreditmemo/storeId/"+storeId+"/customerToken/"+customerId+"/incrementId/"+incrementId+"/creditmemoId/"+creditMemoId
        
        var fileName:String = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        fileName = "credit"+creditMemoId+formatter.string(from: date)+".pdf"
        
        self.load(url: URL(string: url)!, params: "",name: fileName)
        GlobalData.sharedInstance.showLoader()
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

//
//  MyTransactionDetailsController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class MyTransactionDetailsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var id:String = ""
    var transactionDetailsCollectionViewModel:TransactionDetailsCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "mytransactiondetails")
        
        tableView.register(UINib(nibName: "TransactionDetailsTopCell", bundle: nil), forCellReuseIdentifier: "TransactionDetailsTopCell")
        tableView.register(UINib(nibName: "TransactionDetailsBottomCell", bundle: nil), forCellReuseIdentifier: "TransactionDetailsBottomCell")
        
        
        self.tableView.estimatedRowHeight = 250.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        callingHttppApi()
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        requstParams["transactionId"] = id
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/viewTransaction", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.transactionDetailsCollectionViewModel = TransactionDetailsCollectionViewModel(data:dict)
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                print("sss", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1;
        }else{
            return transactionDetailsCollectionViewModel.transactionDetailsCollectionModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:TransactionDetailsTopCell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailsTopCell") as! TransactionDetailsTopCell
            cell.dateValue.text = self.transactionDetailsCollectionViewModel.date
            cell.amountValue.text = self.transactionDetailsCollectionViewModel.amount
            cell.typeValue.text  = self.transactionDetailsCollectionViewModel.type
            cell.methodValue.text = self.transactionDetailsCollectionViewModel.method
            cell.commentValue.text = self.transactionDetailsCollectionViewModel.comment
            
            cell.selectionStyle = .none
            return cell;
        }else{
            let cell:TransactionDetailsBottomCell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailsBottomCell") as! TransactionDetailsBottomCell
            cell.orderLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].incrementId
            cell.productNameLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].productName
            cell.priceLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].price
            cell.qtyLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].qty
            cell.totalValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].totalPrice
            cell.totalTaxLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].totalTax
            cell.totalShippingLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].shipping
            cell.commissionLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].commision
            cell.subtotalLabelValue.text = self.transactionDetailsCollectionViewModel.transactionDetailsCollectionModel[indexPath.row].subTotal
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "#"+self.transactionDetailsCollectionViewModel.transactionId
        }else{
            return "Transaction Order Information"
        }
    }
}

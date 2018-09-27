//
//  CreateCreditMemoViewController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 08/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//


@objc protocol CreateCreditMemoDelegate: class {
    func getdetailsValue(offline:String,refundShipping:String,adjustmentRefund:String,adjustmentFee:String,appendCommentValue:String,visibleonfrontendValue:String,emailCopyValue:String)
    
}



import UIKit

class CreateCreditMemoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,CreateCreditMemoDelegate {

var  incrementId:String = ""
var createCreditMemoListViewModel:CreateCreditMemoListViewModel!
@IBOutlet weak var tableView: UITableView!
var appendCommentValue:String = "0"
var visibleOnFrontEndValue = "0"
var emailCopyoffrontend:String = "0"
var refundShippingValue:String = ""
var adjustmentRefundValue:String = ""
var adjustmentFeeValue:String = ""
var doOfline:String = ""
var commentValue:UITextView!
var whichApiToProcess:String = ""
var parentDict = [String:AnyObject]()

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "creditmemo")
        
        tableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        tableView.register(UINib(nibName: "CreateCreditMemoListItemCell", bundle: nil), forCellReuseIdentifier: "CreateCreditMemoListItemCell")
        tableView.register(UINib(nibName: "CreditMemoCommentCell", bundle: nil), forCellReuseIdentifier: "CreditMemoCommentCell")
        tableView.register(UINib(nibName: "CreditMemoRefundTotalCell", bundle: nil), forCellReuseIdentifier: "CreditMemoRefundTotalCell")
        
        
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
        
        
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "createcreditmemo"{
            
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: parentDict, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["item"] = jsonSortString
                
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["comment"] = commentValue.text
            requstParams["shippingAmount"] = refundShippingValue
            requstParams["adjustmentPositive"] = adjustmentRefundValue
            requstParams["adjustmentNegative"] = adjustmentFeeValue
            requstParams["doOffline"] = doOfline
            requstParams["commentCustomerNotify"] = appendCommentValue
            requstParams["isVisibleOnFront"] = visibleOnFrontEndValue
            requstParams["sendEmail"] = emailCopyoffrontend
            requstParams["invoiceId"] = self.createCreditMemoListViewModel.invoiceId
            
          
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/createcreditmemo", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                         GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                         self.navigationController?.popToRootViewController(animated: true)
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
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/creditMemoFormData", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.createCreditMemoListViewModel = CreateCreditMemoListViewModel(data:dict)
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 4{
           return self.createCreditMemoListViewModel.createCreditMemoListModel.count
        }else{
            return 1
        }
    
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = createCreditMemoListViewModel.billingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = createCreditMemoListViewModel.shippingAddress
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = createCreditMemoListViewModel.paymentMethod
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = createCreditMemoListViewModel.shippingMethod
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section  == 4{
             let cell:CreateCreditMemoListItemCell = tableView.dequeueReusableCell(withIdentifier: "CreateCreditMemoListItemCell") as! CreateCreditMemoListItemCell
             cell.productName.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].productName
             cell.priceLabelValue.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].price
             cell.subtotatalLabelValue.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].subTotal
             cell.taxLabelValue.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].totalTax
             cell.disscountLabelValue.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].discount
             cell.rowTotalLabeklValue.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].rowTotal
            
            var optionData:String = ""
            for i in 0..<self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].sellerQty.count{
                let first = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].sellerQty[i].label
                let second = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].sellerQty[i].value
                optionData = optionData+first!+":"+second!+"\n"
            }
            cell.qtyLabelValue.text = optionData
            cell.switchButton.tag = indexPath.row
            cell.refundTextField.tag = indexPath.row
            cell.createCreditMemoListViewModel = self.createCreditMemoListViewModel;
            cell.refundTextField.text = self.createCreditMemoListViewModel.createCreditMemoListModel[indexPath.row].qty_To_Refund
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 5{
            let cell:CreditMemoCommentCell = tableView.dequeueReusableCell(withIdentifier: "CreditMemoCommentCell") as! CreditMemoCommentCell
            self.commentValue = cell.CommentValue
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:CreditMemoRefundTotalCell = tableView.dequeueReusableCell(withIdentifier: "CreditMemoRefundTotalCell") as! CreditMemoRefundTotalCell
            cell.subtotalLabelValue.text = self.createCreditMemoListViewModel.subTotal
            cell.discountLabelValue.text = self.createCreditMemoListViewModel.discount
            cell.totalTaxLabelValue.text = self.createCreditMemoListViewModel.totalTax
            cell.grandTotalLabelValue.text = self.createCreditMemoListViewModel.grandTotal
            cell.delegate = self
            
            if self.createCreditMemoListViewModel.refundOnlineEnableFlag == 1{
            cell.refundOnlineButton.isHidden = false
            }else{
            cell.refundOnlineButton.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            if self.createCreditMemoListViewModel.shippingAddress == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shippingaddress")
            }
        }else if section == 0{
            return GlobalData.sharedInstance.language(key:"billingaddress");
        }else if section == 2{
            return GlobalData.sharedInstance.language(key:"billingmethod");
        }else if section == 3{
            if self.createCreditMemoListViewModel.shippingMethod == ""{
                return ""
            }else{
                return GlobalData.sharedInstance.language(key:"shipmentmethod")
            }
        }else{
            return ""
        }
    }
    
    func getdetailsValue(offline:String,refundShipping:String,adjustmentRefund:String,adjustmentFee:String,appendCommentValue:String,visibleonfrontendValue:String,emailCopyValue:String){
       self.appendCommentValue = appendCommentValue
       self.visibleOnFrontEndValue = visibleonfrontendValue
       self.emailCopyoffrontend = emailCopyValue
       self.refundShippingValue = refundShipping
       self.adjustmentRefundValue = adjustmentRefund
       self.adjustmentFeeValue = adjustmentFee
       self.doOfline = offline
        
       for i in 0..<self.createCreditMemoListViewModel.createCreditMemoListModel.count{
           var childDict = [String:String]()
           childDict["qty"] = self.createCreditMemoListViewModel.createCreditMemoListModel[i].qty_To_Refund
           childDict["back_to_stock"] = self.createCreditMemoListViewModel.createCreditMemoListModel[i].returnToStock
           parentDict[self.createCreditMemoListViewModel.createCreditMemoListModel[i].itemId] = childDict as AnyObject
        }
        
      whichApiToProcess = "createcreditmemo"
      callingHttppApi()
    }
}

//
//  CreditMemoListViewController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
@IBOutlet weak var tableView: UITableView!
var incrementId:String!
var creditMemoListViewModel:CreditMemoListViewModel!
var creditMemoId:String!
var sendIncrementID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "creditlist")
        
        
        tableView.register(UINib(nibName: "CreditMemoListViewCell", bundle: nil), forCellReuseIdentifier: "CreditMemoListViewCell")
        
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
    
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/creditmemolist", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.creditMemoListViewModel = CreditMemoListViewModel(data:dict)
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
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return self.creditMemoListViewModel.creditMemoList.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CreditMemoListViewCell = tableView.dequeueReusableCell(withIdentifier: "CreditMemoListViewCell") as! CreditMemoListViewCell
        cell.creditmemosLabelValue.text = self.creditMemoListViewModel.creditMemoList[indexPath.row].incrementId
        cell.billTonameLabelValue.text = self.creditMemoListViewModel.creditMemoList[indexPath.row].billToName
        cell.ststusLabelValue.text = self.creditMemoListViewModel.creditMemoList[indexPath.row].status
        cell.createdAtLabelValue.text = self.creditMemoListViewModel.creditMemoList[indexPath.row].createdAt
        cell.amountLabelValue.text = self.creditMemoListViewModel.creditMemoList[indexPath.row].amount
        
        cell.viewButton.addTarget(self, action: #selector(viewDetails(sender:)), for: .touchUpInside)
        cell.viewButton.isUserInteractionEnabled = true;
        cell.selectionStyle = .none
        return cell
    }

    
    
     @objc func viewDetails(sender: UIButton){
         creditMemoId = self.creditMemoListViewModel.creditMemoList[sender.tag].entityId
         sendIncrementID = self.creditMemoListViewModel.creditMemoList[sender.tag].incrementId
         self.performSegue(withIdentifier: "details", sender: self)
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! == "details") {
            let viewController:CreditMemoDetailsController = segue.destination as UIViewController as! CreditMemoDetailsController
            viewController.incrementId = self.incrementId
            viewController.creditMemoId = creditMemoId
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}

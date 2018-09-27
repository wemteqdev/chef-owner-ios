//
//  SellerListController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var searchQuery:String = ""
    var sellerListViewModel:SellerListViewModel!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var sellerId:String = ""
    var sellername:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerlist")
        
        tableView.register(UINib(nibName: "SellerListViewCell", bundle: nil), forCellReuseIdentifier: "SellerListViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        searchTextField.placeholder = "Search Seller By Shop Name";
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
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        requstParams["searchQuery"] = searchQuery
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/sellerlist", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerListViewModel = SellerListViewModel(data:dict)
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
        return self.sellerListViewModel.sellerListModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerListViewCell", for: indexPath) as! SellerListViewCell
        cell.sellerName.setTitle(self.sellerListViewModel.sellerListModel[indexPath.row].shopTitle , for: .normal)
        cell.noOfProducts.text = self.sellerListViewModel.sellerListModel[indexPath.row].productCount
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerListViewModel.sellerListModel[indexPath.row].logo, imageView: cell.sellerImage)
        
        cell.sellerName.addTarget(self, action: #selector(seeSellerProfile(sender:)), for: .touchUpInside)
        cell.sellerName.isUserInteractionEnabled = true;
        cell.sellerName.tag = indexPath.row
        
        cell.viewAllButton.addTarget(self, action: #selector(viewAllData(sender:)), for: .touchUpInside)
        cell.viewAllButton.isUserInteractionEnabled = true;
        cell.viewAllButton.tag = indexPath.row
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    @objc func seeSellerProfile(sender: UIButton){
        self.sellerId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId
        self.performSegue( withIdentifier: "sellerprofile", sender: self)
    }
    
    @objc func viewAllData(sender: UIButton){
        self.sellerId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId
        self.sellername = self.sellerListViewModel.sellerListModel[sender.tag].shopTitle
        self.performSegue( withIdentifier: "productcategory", sender: self)
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! == "sellerprofile") {
            let viewController:SellerDetailsViewController = segue.destination as UIViewController as! SellerDetailsViewController
            viewController.profileUrl = sellerId;
        }else if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = sellername
            viewController.categoryType = "marketplace";
            viewController.sellerId = sellerId
        }
        
        
    }
    
    
    
    
    
    @IBAction func searcButtonPress(_ sender: UIButton) {
        searchQuery = searchTextField.text!
        callingHttppApi()
    }
    
    
    
    
    
}

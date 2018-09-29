//
//  Chef_SellerListController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 19/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_SellerListController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    var searchQuery:String = ""
    var sellerListViewModel:Chef_SellerListViewModel!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var sellerId:String = ""
    var sellername:String = ""
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        searchButton.isHidden = true
        searchTextField.isHidden = true
       
        let origImage = UIImage(named: "Action 2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
       
        self.navigationController?.isNavigationBarHidden = false
        
        var btnCart:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Action 4"), style: .plain , target: self, action: #selector(searchButtonClick(sender:)))
        
        var btnSearch:UIBarButtonItem = UIBarButtonItem(image: tintedImage , style: .plain, target: self, action: #selector(cartButtonClick(sender:)))
        btnCart.tintColor = .white
        btnSearch.tintColor = .white
        self.navigationItem.setRightBarButtonItems([btnCart, btnSearch], animated: true)
        //navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerlist")
        
        tableView.register(UINib(nibName: "Chef_SellerListViewCell", bundle: nil), forCellReuseIdentifier: "Chef_SellerListViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        searchTextField.placeholder = "Search Supplier By Shop Name";
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        tableView.reloadData()
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

                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerListViewModel = Chef_SellerListViewModel(data:dict)
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    
                    
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
                GlobalData.sharedInstance.dismissLoader()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chef_SellerListViewCell", for: indexPath) as! Chef_SellerListViewCell
    cell.sellerName.setTitle(self.sellerListViewModel.sellerListModel[indexPath.row].shopTitle , for: .normal)
        cell.noOfProducts.text = self.sellerListViewModel.sellerListModel[indexPath.row].productCount
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerListViewModel.sellerListModel[indexPath.row].logo, imageView: cell.sellerImage)
        
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerListViewModel.sellerListModel[indexPath.row].logo, imageView: cell.sellerImage)
        //cell.sellerImage.image = UIImage(named: "ic_profile")
        
        cell.sellerName.addTarget(self, action: #selector(seeSellerProfile(sender:)), for: .touchUpInside)
        cell.sellerName.isUserInteractionEnabled = true;
        cell.sellerName.tag = indexPath.row
        
        cell.viewAllButton.addTarget(self, action: #selector(viewAllData(sender:)), for: .touchUpInside)
        cell.viewAllButton.isUserInteractionEnabled = true;
        cell.viewAllButton.tag = indexPath.row
        
        cell.viewMapButton.addTarget(self, action: #selector(viewMap(sender:)), for: .touchUpInside)
        cell.viewMapButton.isUserInteractionEnabled = true;
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    @objc func seeSellerProfile(sender: UIButton){
//        self.sellerId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId
//        self.performSegue( withIdentifier: "sellerprofile", sender: self)
    }
    
    @objc func viewAllData(sender: UIButton){
        tabBarController?.selectedIndex = 1
//        self.sellerId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId
//        self.sellername = self.sellerListViewModel.sellerListModel[sender.tag].shopTitle
//        self.performSegue( withIdentifier: "productcategory", sender: self)
    }
    @objc func viewMap(sender: UIButton){        
        self.performSegue( withIdentifier: "mapview", sender: self)
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
    
    @objc func cartButtonClick(sender: UIButton){
    }
    @objc func searchButtonClick(sender: UIButton){
    }
    
    
    @IBAction func searcButtonPress(_ sender: UIButton) {
        searchQuery = searchTextField.text!
        callingHttppApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

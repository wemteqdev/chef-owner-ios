//
//  ChefsDashboardController.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/18/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class ChefSuppliersDashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate,
    supplierViewControllerHandlerDelegate
{
    
    @IBOutlet weak var suppliersTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addSupplierButton: UIBarButtonItem!
    @IBOutlet weak var searchBarView: UIView!
    
    var searchActive : Bool = false
    var filtered:[SupplierInfoModel] = [];
    var addSupplierEmail:String = "";
    var callingApiSucceed: Bool = false;
    var suppliersInfo:SuppliersViewModel!;
    var selectedSupplierId = 0;
    var selectedSupplierName = "";
    @objc func cartButtonClick(sender: UIButton){
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_cartexview") as! Chef_exMyCart
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_supercartview") as! Chef_SuperCart
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func searchButtonClick(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_searchview") as! SearchSuggestion
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func loadNavgiationButtons() {
        let btnCart = SSBadgeButton()
        
        btnCart.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btnCart.setImage(UIImage(named: "Action 4")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCart.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        btnCart.badge = badge
        print("Load Navigation Button Function Badge Value")
        print(badge)
        
        btnCart.addTarget(self, action: #selector(cartButtonClick(sender:)), for: .touchUpInside)
        
        var origImage = UIImage(named: "Action 2")
        var tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        var btnSearch:UIBarButtonItem = UIBarButtonItem(image: tintedImage , style: .plain, target: self, action: #selector(searchButtonClick(sender:)))
        
        btnCart.tintColor = .white
        btnSearch.tintColor = .white
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: btnCart), btnSearch], animated: true)
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func viewMapClick(id:Int)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! MapViewController
        for supplierInfo in self.suppliersInfo.suppliersInfo {
            if(supplierInfo.supplierId == id){
                vc.supplierName = supplierInfo.supplierName;
                vc.supplierAddress = supplierInfo.address;
                vc.customerName = supplierInfo.supplierName;
                vc.customerAddress = supplierInfo.address;
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func browseCategory(id: Int, name: String)
    {
        self.selectedSupplierName = name;
        self.selectedSupplierId = id;
        self.performSegue( withIdentifier: "productcategory", sender: self)
    }
    
    func signupSupplier(id:Int)
    {
        self.selectedSupplierId = id;
        let alertController = UIAlertController(title: "Alert", message: "Are you sure to sign up this supplier?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.callingHttppApiForApproveSupplier(id: id);
        }
        let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(action2)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func callingHttppApiForApproveSupplier(id: Int){
        var requstParams = [String:Any]();
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
        }
        requstParams["supplierId"] = id; //supplier
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/supplier/approvesupplier", currentView: self){success,responseObject in
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
                    var message = "";
                    var title = "";
                    if dict["approveSupplierSucceed"] == true {
                        message = "Supplier approved successfully"
                        title = "Success";
                        for index in 0...self.suppliersInfo.suppliersInfo.count - 1 {
                            if (self.suppliersInfo.suppliersInfo[index].supplierId == id){
                                self.suppliersInfo.suppliersInfo[index].status = 1;
                                break;
                            }
                        }
                        self.suppliersTableView.reloadData();
                    } else {
                        message = "Supplier approving is failed"
                        title = "Error";
                    }
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action2 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
                        print("You've pressed cancel");
                    }
                    alertController.addAction(action2)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
            print("supplier approve", responseObject)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

        if(segue.identifier! == "sellerprofile") {
            let viewController:SellerDetailsViewController = segue.destination as UIViewController as! SellerDetailsViewController
            //viewController.profileUrl = sellerId;
        }else if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = String(selectedSupplierName);
            viewController.categoryType = "marketplace";
            viewController.sellerId = String(selectedSupplierId);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavgiationButtons()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "back_color"), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage();
        searchBarView.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
        
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "Supplier")
        suppliersTableView.register(UINib(nibName: "SuppliersCell", bundle: nil), forCellReuseIdentifier: "SuppliersCell")
        suppliersTableView.rowHeight = UITableViewAutomaticDimension
        self.suppliersTableView.estimatedRowHeight = 50
        self.suppliersTableView.separatorColor = UIColor.clear
        let whiteColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0);
        self.searchBar.barTintColor = whiteColor;
        self.searchBar.setSearchFieldBackgroundImage(UIImage(named: "white_color"), for: UIControlState.normal)
        suppliersTableView.delegate = self
        suppliersTableView.dataSource = self
        self.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callingHttppApi();
        suppliersTableView.dataSource = self
        suppliersTableView.delegate = self
        suppliersTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
        }
        requstParams["customerType"] =  2; //chef
        self.callingApiSucceed = false;
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/supplier/getsuppliers", currentView: self){success,responseObject in
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
                    self.suppliersInfo = SuppliersViewModel(data:dict);
                    print("supplierInfo:", self.suppliersInfo.suppliersInfo);
                    self.callingApiSucceed = true;
                    self.suppliersTableView.reloadData();
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
            print("supplier", responseObject)
        }
    }
    //---search bar----
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.callingApiSucceed){
            print("searchActive:", searchActive);
            filtered = self.suppliersInfo.suppliersInfo.filter({ (supplierInfo: SupplierInfoModel) -> Bool in
                print("supplierEmail: ", supplierInfo.email);
                return supplierInfo.email.lowercased().contains(searchText.lowercased())
            })
            
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
            
            self.suppliersTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource and Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.callingApiSucceed){
            if (searchActive) {
                return filtered.count
            }
            return self.suppliersInfo.suppliersInfo.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SuppliersCell = tableView.dequeueReusableCell(withIdentifier: "SuppliersCell") as! SuppliersCell
        if (self.callingApiSucceed){
            if (searchActive) {
                if(filtered.count == 0)
                {
                    cell.supplierName.text = "No Result";
                }
                else {
                    cell.supplierName.text = filtered[indexPath.section].supplierName as? String;
                    cell.supplierImage.image = UIImage(named: "ic_signin")!
                    if(filtered[indexPath.section].customerImage != nil) {
                        GlobalData.sharedInstance.getImageFromUrl(imageUrl: filtered[indexPath.section].customerImage, imageView: cell.supplierImage)
                    }
                    cell.supplierId = filtered[indexPath.section].supplierId;
                    cell.status = filtered[indexPath.section].status;
                    if (filtered[indexPath.section].status == 1) {
                        cell.statusButton.backgroundColor = UIColor(red: 233/255, green: 248/255, blue: 239/255, alpha: 1.0);
                        cell.statusButton.layer.borderColor = UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0).cgColor;
                        cell.statusButton.layer.borderWidth = 1;
                        cell.statusButton.setTitleColor(UIColor(red: 39/255, green: 183/255, blue: 243/255, alpha: 1.0), for: .normal)
                        cell.statusButton.setTitle("Browse Catalogue", for: .normal);
                    } else {
                        cell.statusButton.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0);
                        cell.statusButton.layer.borderColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0).cgColor;
                        cell.statusButton.layer.borderWidth = 1;
                        cell.statusButton.setTitleColor(UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0), for: .normal)
                        cell.statusButton.setTitle("Sign Up", for: .normal);
                    }
                }
            }
            else
            {
                cell.supplierName.text = self.suppliersInfo.suppliersInfo[indexPath.section].supplierName as? String;
                cell.supplierImage.image = UIImage(named: "ic_signin")!
                if(self.suppliersInfo.suppliersInfo[indexPath.section].customerImage != nil) {
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.suppliersInfo.suppliersInfo[indexPath.section].customerImage, imageView: cell.supplierImage)
                }
                cell.supplierId = self.suppliersInfo.suppliersInfo[indexPath.section].supplierId;
                cell.status = self.suppliersInfo.suppliersInfo[indexPath.section].status;
                if (self.suppliersInfo.suppliersInfo[indexPath.section].status == 1) {
                    cell.statusButton.backgroundColor = UIColor(red: 233/255, green: 248/255, blue: 239/255, alpha: 1.0);
                    cell.statusButton.layer.borderColor = UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0).cgColor;
                    cell.statusButton.layer.borderWidth = 1;
                    cell.statusButton.setTitleColor(UIColor(red: 39/255, green: 183/255, blue: 243/255, alpha: 1.0), for: .normal)
                    cell.statusButton.setTitle("Browse Catalogue", for: .normal);
                } else {
                    cell.statusButton.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0);
                    cell.statusButton.layer.borderColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0).cgColor;
                    cell.statusButton.layer.borderWidth = 1;
                    cell.statusButton.setTitleColor(UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0), for: .normal)
                    cell.statusButton.setTitle("Sign Up", for: .normal);
                }
            }
        }
        cell.delegate = self;
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "customerprofileview") as! CustomerProfileViewController
        vc.customerId = self.suppliersInfo.suppliersInfo[indexPath.section].supplierId;
        vc.customerImage = self.suppliersInfo.suppliersInfo[indexPath.section].customerImage;
        self.navigationController?.pushViewController(vc, animated: true)
    }
            
}



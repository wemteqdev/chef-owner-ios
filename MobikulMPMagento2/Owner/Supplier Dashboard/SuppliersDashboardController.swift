//
//  ChefsDashboardController.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/18/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class SuppliersDashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate,
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
    
    func viewMapClick(id:String)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! MapViewController
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
        if(segue.identifier! == "sellerprofile") {
            let viewController:SellerDetailsViewController = segue.destination as UIViewController as! SellerDetailsViewController
            //viewController.profileUrl = sellerId;
        }else if (segue.identifier! == "productcategory") {
            let viewController:SupplierProductcategory = segue.destination as UIViewController as! SupplierProductcategory
            viewController.categoryName = String(selectedSupplierName);
            viewController.categoryType = "marketplace";
            viewController.sellerId = String(selectedSupplierId);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    //---add chef------
    
    @IBAction func addChef(_ sender: Any) {
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "addSupplierAlertView") as! AddSupplierAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
 
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
        requstParams["customerType"] =  1; //owner
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
    func callingHttppApiForAddSupplier(){
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
        requstParams["isChefOrRestaurant"] = 3; //supplier
        requstParams["addSupplierEmail"] = addSupplierEmail;
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/addcustomer", currentView: self){success,responseObject in
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
                    print("addSupplier dict", dict["addSupplier"]);
                    let suppliersInfo = AddSupplierInfoModel(data:dict["addSupplier"]);
                    if suppliersInfo.isAddSuccess == true {
                        print("supplierInfo:", suppliersInfo.supplierInfo);
                        self.suppliersInfo.suppliersInfo.append(suppliersInfo.supplierInfo);
                        self.suppliersTableView.reloadData();
                    } else {
                        let alertController = UIAlertController(title: "Error", message: suppliersInfo.errorMessage, preferredStyle: .alert)
                        let action2 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
                            print("You've pressed cancel");
                        }
                        alertController.addAction(action2)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApiForAddSupplier()
            }
            print("addSupplier", responseObject)
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailPage") as! DetailPage
        vc.pageType = 3;
        self.navigationController?.pushViewController(vc, animated: true)
    }
            
}

extension SuppliersDashboardController: AddSupplierAlertViewDelegate {
    
    func okButtonTapped(textFieldValue: String) {
        print("TextField has value: \(textFieldValue)")
        self.addSupplierEmail = textFieldValue;
        self.callingHttppApiForAddSupplier();
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}


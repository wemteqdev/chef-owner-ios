//
//  ChefsDashboardController.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/18/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class ChefsDashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate, removeFromOwnerHandlerDelegate {
    
    func removeButtonClick(id: Int) {
        print("id:", id);
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure to remove this chef?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.callingHttppApiForRemoveChef(id: id);
        }
        let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(action2)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var chefsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addChefButton: UIBarButtonItem!
    @IBOutlet weak var searchBarView: UIView!
    var callingApiSucceed:Bool = false;

    var searchActive : Bool = false
    var filtered:[ChefInfoModel] = [];
    var addChefEmail:String = "";
    var addChefRestaurantId: Int = -1;
    var chefDashboardModelView:ChefDashboardModelView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "back_color"), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage();
        searchBarView.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
        
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "chef")
        chefsTableView.register(UINib(nibName: "ChefsCell", bundle: nil), forCellReuseIdentifier: "ChefsCell")
        chefsTableView.rowHeight = UITableViewAutomaticDimension
        self.chefsTableView.estimatedRowHeight = 50
        self.chefsTableView.separatorColor = UIColor.clear
        let whiteColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0);
        self.searchBar.barTintColor = whiteColor;
        self.searchBar.setSearchFieldBackgroundImage(UIImage(named: "white_color"), for: UIControlState.normal)
        
        chefsTableView.delegate = self
        chefsTableView.dataSource = self
        self.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callingHttppApi();
        chefsTableView.dataSource = self
        chefsTableView.delegate = self
        chefsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    //---add chef------
    
    @IBAction func addChef(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "addChefAlertView") as! AddChefAlertView
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
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/getchefinfos", currentView: self){success,responseObject in
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
                    print("chefinfos:", responseObject)
                    self.chefDashboardModelView = ChefDashboardModelView(data:dict);
                    self.callingApiSucceed = true;
                    self.chefsTableView.reloadData();
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    
    func callingHttppApiForAddChef(){
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
        requstParams["isChefOrRestaurant"] = 1; //chef
        requstParams["restaurantId"] = addChefRestaurantId;
        requstParams["addChefEmail"] = addChefEmail;
        
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
                    var chefInfo = AddChefInfoModel(data:dict["addChef"]);
                    if chefInfo.isAddSuccess == true {
                        print("chefInfo:", chefInfo.chefInfo);
                        self.chefDashboardModelView.chefInfos.append(chefInfo.chefInfo);
                        self.chefsTableView.reloadData();
                    } else {
                        let alertController = UIAlertController(title: "Error", message: chefInfo.errorMessage, preferredStyle: .alert)
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
                self.callingHttppApiForAddChef()
            }
            print("addChef", responseObject)
        }
    }
    
    func callingHttppApiForRemoveChef(id: Int){
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
        requstParams["chefId"] = id; //chef
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/removechef", currentView: self){success,responseObject in
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
                    if dict["removeChefSuccess"] == true {
                        message = "Chef removed successfully"
                        title = "Success";
                        for index in 0...self.chefDashboardModelView.chefInfos.count - 1 {
                            if (self.chefDashboardModelView.chefInfos[index].chefId == id){
                                self.chefDashboardModelView.chefInfos.remove(at: index);
                                break;
                            }
                        }
                        self.chefsTableView.reloadData();
                    } else {
                        message = "Chef removing is failed"
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
                self.callingHttppApiForRemoveChef(id: id)
            }
            print("removing", responseObject)
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
        
        print("searchActive:", searchActive);
        filtered = self.chefDashboardModelView.chefInfos.filter({ (chefInfo: ChefInfoModel) -> Bool in
            print("chefEmail: ", chefInfo.chefEmail);
            return chefInfo.chefEmail.lowercased().contains(searchText.lowercased())
        })
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.chefsTableView.reloadData()
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
        
        if (searchActive) {
            return filtered.count
        }
        if (self.callingApiSucceed){
            return self.chefDashboardModelView.chefInfos.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChefsCell = tableView.dequeueReusableCell(withIdentifier: "ChefsCell") as! ChefsCell
        if (self.callingApiSucceed){
            if (searchActive) {
                if(filtered.count == 0)
                {
                    cell.chefName.text = "No Result";
                }
                else {
                    cell.chefName.text = filtered[indexPath.section].chefFirstName + " " +
                        filtered[indexPath.section].chefLastName as? String;
                    cell.restaruantName.text = filtered[indexPath.section].restaurantName as? String;
                    cell.chefImage.image = UIImage(named: "ic_signin")!
                    cell.chefId = filtered[indexPath.section].chefId;
                }
            }
            else
            {
                cell.chefName.text = self.chefDashboardModelView.chefInfos[indexPath.section].chefFirstName + " " +
                    self.chefDashboardModelView.chefInfos[indexPath.section].chefLastName as? String;
                cell.restaruantName.text = self.chefDashboardModelView.chefInfos[indexPath.section].restaurantName as? String;
                cell.chefImage.image = UIImage(named: "ic_signin")!
                cell.chefId = self.chefDashboardModelView.chefInfos[indexPath.section].chefId;
            }
        }
        //cell.chefImage.image = UIImage(named: "ic_signin")!
        cell.selectionStyle = .none
        cell.delegate = self;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailPage") as! DetailPage
        vc.pageType = 1;
        vc.customerId = self.chefDashboardModelView.chefInfos[indexPath.section].chefId;
        self.navigationController?.pushViewController(vc, animated: true)
    }
            
}

extension ChefsDashboardController: AddChefAlertViewDelegate {
    
    func okButtonTapped(textFieldValue: String, restaurantIdValue: Int) {
        print("TextField has value: \(textFieldValue)")
        print("restaurantIdValue has value: \(restaurantIdValue)")
        self.addChefEmail = textFieldValue;
        self.addChefRestaurantId = restaurantIdValue;
        self.callingHttppApiForAddChef();
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}

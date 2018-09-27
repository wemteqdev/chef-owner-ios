//
//  AddressBookController.swift
//  Magento2V4Theme
//
//  Created by kunal on 12/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit




class AddressBookController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    var addressBookViewModel:AddressBookViewModel!
    
    
    @IBOutlet weak var addnewAddressButton: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    var addoredit:String = ""
    var addressId:String = "0"
    var whichApiDataToProcess:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        addressTableView.register(UINib(nibName: "AddressViewCell", bundle: nil), forCellReuseIdentifier: "AddressViewCell")
        addressTableView.register(UINib(nibName: "AddreessViewCell2", bundle: nil), forCellReuseIdentifier: "AddreessViewCell2")
        addressTableView.register(UINib(nibName: "AddressViewCell3", bundle: nil), forCellReuseIdentifier: "AddressViewCell3")
        addressTableView.rowHeight = UITableViewAutomaticDimension
        self.addressTableView.estimatedRowHeight = 100
        self.addressTableView.separatorColor = UIColor.clear
        addnewAddressButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        addnewAddressButton.setTitle(GlobalData.sharedInstance.language(key: "addnewaddress"), for: .normal)
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
        callingHttppApi()
    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        
        
        if whichApiDataToProcess == "deleteAddress"{
            var requstParams = [String:Any]();
            requstParams["addressId"] = addressId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/deleteAddress", currentView: self){success,responseObject in
                if success == 1{
                    
                    let data = responseObject as! NSDictionary
                    print(data)
                    GlobalData.sharedInstance.dismissLoader()
                    let errorCode = data .object(forKey:"success") as! Bool
                    if errorCode == true{
                        self.whichApiDataToProcess = ""
                        self.callingHttppApi()
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: "Something went wrong ..Please try again")
                        
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/addressBookData", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    print(responseObject)
                    self.addressBookViewModel = AddressBookViewModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingWithResult()
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    
    func doFurtherProcessingWithResult(){
        addressTableView.delegate = self
        addressTableView.dataSource = self
        addressTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 || section == 1{
            return 1
        }else{
            return self.addressBookViewModel.additionalAddressCollection.count;
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return GlobalData.sharedInstance.language(key: "BillingAddress")
        }else if section == 1{
            return GlobalData.sharedInstance.language(key: "ShippingAddress")
        }else{
            return GlobalData.sharedInstance.language(key: "AdditionalAddress")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressViewCell", for: indexPath) as! AddressViewCell
            cell.addressValue.text = self.addressBookViewModel.addressBookModel.billingAddress
            cell.deleteButton.isHidden = true
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editBillingAddressButtonTapped(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddreessViewCell2", for: indexPath) as! AddreessViewCell2
            cell.addressValue.text = self.addressBookViewModel.addressBookModel.shippingAddress
            cell.deleteButton.isHidden = true
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editShippingAddressButtonTapped(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressViewCell3", for: indexPath) as! AddressViewCell3
            cell.addressValue.text = self.addressBookViewModel.additionalAddressCollection[indexPath.row].value
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editAddressButtonTapped(sender:)), for: .touchUpInside)
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteAddress(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @IBAction func AddnewAddressClick(_ sender: UIButton) {
        addoredit = "0"
        self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func editAddressButtonTapped(sender: UIButton){
        addoredit = "1";
        addressId = self.addressBookViewModel.additionalAddressCollection[sender.tag].id
        self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func editShippingAddressButtonTapped(sender: UIButton){
        if self.addressBookViewModel.addressBookModel.shippingId == 0{
            addoredit = "0"
        }else{
            addoredit = "1"
            addressId = self.addressBookViewModel.addressBookModel.shippingIdValue
        }
        self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func editBillingAddressButtonTapped(sender: UIButton){
        if self.addressBookViewModel.addressBookModel.billingId == 0{
            addoredit = "0"
        }else{
            addoredit = "1"
            addressId = self.addressBookViewModel.addressBookModel.billingIdValue
        }
        self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func deleteAddress(sender: UIButton){
        whichApiDataToProcess = "deleteAddress";
        addressId = self.addressBookViewModel.additionalAddressCollection[sender.tag].id
        
        let AC = UIAlertController(title:GlobalData.sharedInstance.language(key: "warning"), message: GlobalData.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addeditaddress") {
            let viewController:AddEditAddress = segue.destination as UIViewController as! AddEditAddress
            viewController.addOrEdit = self.addoredit
            viewController.addressId = addressId
        }
    }
}

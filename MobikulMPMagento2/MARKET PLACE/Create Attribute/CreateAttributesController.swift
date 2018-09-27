//
//  CreateAttributesController.swift
//  ShangMarket
//
//  Created by kunal on 03/04/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class CreateAttributesController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var createAttributeViewModel:CreateAttributeViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    var attributeOption:NSMutableArray = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAttributeViewModel = CreateAttributeViewModel(data: "")
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "createattribute")
        tableView.register(UINib(nibName: "TopCreateCell", bundle: nil), forCellReuseIdentifier: "TopCreateCell")
        tableView.register(UINib(nibName: "BottomCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "BottomCreateTableViewCell")
        
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        saveButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitle(GlobalData.sharedInstance.language(key: "save"), for: .normal)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey:"storeId");
        if storeId != nil{
            requstParams["storeId"] = storeId as! String
        }
        requstParams["attributeCode"] = createAttributeViewModel.topCreateDataModdel.attributeCode
        requstParams["attributeLabel"] = createAttributeViewModel.topCreateDataModdel.attributeLabel
        requstParams["isRequired"] = createAttributeViewModel.topCreateDataModdel.valueRequired
        requstParams["attributeType"]  = "select"
        
        
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: attributeOption, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["attributeOption"] = jsonSortString
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/product/saveattribute", currentView: self){success,responseObject in
            if success == 1{
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].intValue == 1{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                }else{
                    GlobalData.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                }
                print("sfsfs", responseObject!)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return createAttributeViewModel.bottonCreateAttributeData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:TopCreateCell = tableView.dequeueReusableCell(withIdentifier: "TopCreateCell") as! TopCreateCell
            cell.attributeCodeValueField.text = createAttributeViewModel.topCreateDataModdel.attributeCode
            cell.attributeLabelField.text = createAttributeViewModel.topCreateDataModdel.attributeLabel
            if createAttributeViewModel.topCreateDataModdel.valueRequired == "1"{
                cell.valueChangeSwitch.isOn = true
            }else{
                cell.valueChangeSwitch.isOn = false
            }
            cell.createAttributeViewModel = self.createAttributeViewModel
            cell.addanotherButton.addTarget(self, action: #selector(AddAnotherCell(sender:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:BottomCreateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BottomCreateTableViewCell") as! BottomCreateTableViewCell
            cell.createAttributeViewModel = self.createAttributeViewModel
            cell.adminField.text = createAttributeViewModel.bottonCreateAttributeData[indexPath.row].admin
            cell.defaultStoreViewField.text = createAttributeViewModel.bottonCreateAttributeData[indexPath.row].defaultStoreViewData
            cell.positionField.text = createAttributeViewModel.bottonCreateAttributeData[indexPath.row].position
            if createAttributeViewModel.bottonCreateAttributeData[indexPath.row].isDefault == "on"{
                cell.isDefaultSwitch.isOn = true
            }else{
                cell.isDefaultSwitch.isOn = false
            }
            cell.adminField.tag = indexPath.row
            cell.defaultStoreViewField.tag = indexPath.row
            cell.positionField.tag = indexPath.row
            cell.isDefaultSwitch.tag = indexPath.row
            cell.removeButton.tag = indexPath.row
            
            cell.removeButton.addTarget(self, action: #selector(RemoveCell(sender:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func AddAnotherCell(sender: UIButton){
        createAttributeViewModel.setNewBottomAttributeData()
        self.tableView.reloadData()
    }
    
    @objc func RemoveCell(sender: UIButton){
        createAttributeViewModel.removeNewBottomAttributeData(pos: sender.tag)
        self.tableView.reloadData()
    }
    
    @IBAction func saveButtonClick(_ sender: UIButton) {
        var isValid:Int = 1
        var errorMessage:String = "Please fill"+" "
        
        if createAttributeViewModel.topCreateDataModdel.attributeCode == ""{
            isValid = 0
            errorMessage = errorMessage+"Attribute Code"
        }else if createAttributeViewModel.topCreateDataModdel.attributeLabel == ""{
            isValid = 0
            errorMessage = errorMessage+"Attribute Label"
        }
        else if createAttributeViewModel.bottonCreateAttributeData.count > 0{
            
            for i in 0..<createAttributeViewModel.bottonCreateAttributeData.count{
                if createAttributeViewModel.bottonCreateAttributeData[i].admin == ""{
                    isValid = 0
                    errorMessage = errorMessage+"Admin Value"
                }else if createAttributeViewModel.bottonCreateAttributeData[i].defaultStoreViewData == ""{
                    isValid = 0
                    errorMessage = errorMessage+"Default Store View"
                }else if createAttributeViewModel.bottonCreateAttributeData[i].position == ""{
                    isValid = 0
                    errorMessage = errorMessage+"Postion"
                }
            }
        }
        
        if isValid == 0{
            GlobalData.sharedInstance.showWarningSnackBar(msg: errorMessage)
        }else{
            attributeOption = []
            if createAttributeViewModel.bottonCreateAttributeData.count > 0{
                for i in 0..<createAttributeViewModel.bottonCreateAttributeData.count{
                    var dict = [String:String]()
                    dict["admin"] = createAttributeViewModel.bottonCreateAttributeData[i].admin
                    dict["store"] = createAttributeViewModel.bottonCreateAttributeData[i].defaultStoreViewData
                    dict["position"] = createAttributeViewModel.bottonCreateAttributeData[i].position
                    dict["isdefault"] = createAttributeViewModel.bottonCreateAttributeData[i].isDefault
                    attributeOption.add(dict)
                }
            }
            callingHttppApi()
        }
    }
}

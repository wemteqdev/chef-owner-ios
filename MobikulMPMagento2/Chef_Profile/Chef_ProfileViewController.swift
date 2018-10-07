//
//  Chef_ProfileViewController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 07/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var profileTableView: UITableView!
    var profileData:NSMutableArray = ["Photo","First Name", "Second Name", "Restautrant Name", "Email", "Phone Number", "Address", "City", "State", "Post Code", "Country"]
    var accountInfoModel:AccountInformationModel!
    var didload:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        profileTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 50
        self.profileTableView.separatorColor = UIColor.clear
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        callingHttppApi()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200
        }else{
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            if defaults.object(forKey: "customerEmail") != nil{
                cell.profileEmail.text = defaults.object(forKey: "customerEmail") as? String
            }
            if defaults.object(forKey: "customerName") != nil{
                cell.profileName.text = defaults.object(forKey: "customerName") as? String
            }
            if defaults.object(forKey: "profilePicture") != nil{
                let imageUrl = defaults.object(forKey: "profilePicture") as? String
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl!, imageView: cell.profileImage)
            }
            if defaults.object(forKey: "profileBanner") != nil{
                let imageUrl = defaults.object(forKey: "profileBanner") as? String
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl!, imageView: cell.profileBannerImage)
            }
          
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.name.text = profileData[indexPath.row - 1] as! String
            if didload != false{
                switch indexPath.row - 1 {
                case 0:
                    cell.nameValue.isHidden = true
                    cell.changeButton.isHidden = false
                    break
                case 1:
                    cell.nameValue.text = accountInfoModel.firstName
                    break
                case 2:
                    cell.nameValue.text = accountInfoModel.lastName
                    break
                case 3:
                    cell.nameValue.text = ""
                    break
                case 4:
                    cell.nameValue.text = accountInfoModel.emailId
                    break
                case 5:
                    cell.nameValue.text = accountInfoModel.mobileNumber
                    break
                case 6:
                    cell.nameValue.text = accountInfoModel.street
                    break
                case 7:
                    cell.nameValue.text = accountInfoModel.city
                    break
                case 8:
                    cell.nameValue.text = accountInfoModel.state
                    break
                case 9:
                    cell.nameValue.text = accountInfoModel.postcode
                    break
                    
                default:
                    cell.nameValue.text = accountInfoModel.country
                    break
                    
                }
            }
            return cell
        }
    }
    func callingHttppApi(){
        DispatchQueue.main.async {
        GlobalData.sharedInstance.showLoader()
//        if whichApiToProcess == "customerEditPost"{
//            var requstParams = [String:Any]();
//            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
//            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
//            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
//            requstParams["firstName"] = firstNameTextField.text
//            requstParams["lastName"] = lasttNametextField.text
//            requstParams["email"] = emailtextField.text
//            requstParams["prefix"] = prefixTextField.text
//            requstParams["suffix"] = suffixtextField.text
//            requstParams["middleName"] = middleNameTextField.text
//            requstParams["mobile"] = mobileNumbertextFeild.text
//            requstParams["dob"] = dobTextFeild.text
//            requstParams["taxvat"] = taxValuetextField.text
//            requstParams["currentPassword"] = currentPasswordTextField.text
//            var value:String = ""
//            if genderTextFeild.text == "Male"{
//                value = "1"
//            }else if genderTextFeild.text == "Female"{
//                value = "0"
//            }
//            requstParams["newPassword"] = confirmNewTextField.text
//            requstParams["confirmPassword"] = confirmtextFeild.text
//            if changePasswordFlag == true{
//                requstParams["doChangePassword"] = "1"
//            }else{
//                requstParams["doChangePassword"] = "0"
//            }
//
//            if changeEmailFlag == true{
//                requstParams["doChangeEmail"] = "1"
//            }else{
//                requstParams["doChangeEmail"] = "0"
//            }
//
//
//
//            requstParams["gender"] = value
//
//            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/saveAccountInfo", currentView: self){success,responseObject in
//                if success == 1{
//
//                    GlobalData.sharedInstance.dismissLoader()
//
//
//                    let dict = responseObject as! NSDictionary
//
//                    print(dict)
//                    if dict.object(forKey: "success") as! Bool == true{
//                        GlobalData.sharedInstance.showSuccessMessageWithBack(view: self,message:dict.object(forKey: "message") as! String )
//
//                        var name = self.firstNameTextField.text!+" "+self.lasttNametextField.text!
//                        self.defaults.set(name, forKey: "customerName")
//                        self.defaults.synchronize()
//                        self.navigationController?.popViewController(animated: true)
//
//                    }else{
//                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
//                    }
//
//                }else if success == 2{
//                    GlobalData.sharedInstance.dismissLoader()
//                    self.callingHttppApi()
//                }
//            }
//        }else{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/accountInfoData", currentView: self){success,responseObject in
                if success == 1{
                    
                    print((responseObject as! NSDictionary))
                    self.accountInfoModel  = AccountInformationModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingwithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        
      //  }
        }
        
    }
    func doFurtherProcessingwithResult(){
        GlobalData.sharedInstance.dismissLoader()
        didload = true
      
        profileTableView.reloadData()
        
        
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

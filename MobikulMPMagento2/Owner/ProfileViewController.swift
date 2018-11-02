//
//  Chef_ProfileViewController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 07/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditProfiledelegate {
    func saveData(data: String, id: Int) {
        switch id+1 {
        case 1:
            accountInfoModel.firstName = data;
            let name = accountInfoModel.firstName + " " + accountInfoModel.lastName;
            defaults.set(name, forKey: "customerName")
            break
        case 2:
            accountInfoModel.lastName = data;
            let name = accountInfoModel.firstName + " " + accountInfoModel.lastName;
            defaults.set(name, forKey: "customerName")
            break
        case 3:
            accountInfoModel.emailId = data;
            defaults.set(accountInfoModel.emailId, forKey: "customerEmail")
            break
        case 4:
            accountInfoModel.mobileNumber = data;
            break
        case 5:
            accountInfoModel.street = data;
            break
        case 6:
            accountInfoModel.city = data;
            break
        case 7:
            accountInfoModel.state = data;
            break
        case 8:
            accountInfoModel.postcode = data;
            break
            
        case 9:
            accountInfoModel.country = data;
            break
            
        default:
            break
        }
        self.profileTableView.reloadData();
    }
    func saveProfileImage() {
        self.uploadProfilePic();
    }
    func saveProfile(){
        print("save clicked")
        self.whichApiToProcess = "customerEditPost";
        self.callingHttppApi();
    }
    
    @IBOutlet weak var profileTableView: UITableView!
    var supplierProfileData:NSMutableArray = ["Photo", "First Name", "Second Name", "Email", "Phone Number", "Address", "City", "State", "Post Code", "Country"]
    var supplierProfileDataValue:NSMutableArray = ["", "", "", "", "", "", "", "", ""]
    var accountInfoModel:AccountInformationModel!
    var didload:Bool = false
    var whichApiToProcess:String = "";
    var imageData:NSData!
    var uploadImage:String = ""
    var fileName:String = ""
    var indexforcell:Int = 0;
    var originalName:String = ""
    var originalEmail:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        profileTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 50
        self.profileTableView.separatorColor = UIColor.clear
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        self.profileTableView.layer.shadowOpacity = 0;
        self.profileTableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        //queue.maxConcurrentOperationCount = 20;
        //let backItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: "tapToBack")
        //self.navigationItem.leftBarButtonItem = backItem
        
        callingHttppApi()
        
        
        // Do any additional setup after loading the view.
    }
    @objc func tapToBack() {
        print("back clicked")
    }
    override func viewWillAppear(_ animated: Bool) {        
        if(uploadImage == "true"){
            self.uploadImageRequest();
        }        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplierProfileData.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 195
        }else{
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row - 2 >= 0){
            self.indexforcell = indexPath.row - 2;
            self.performSegue(withIdentifier: "editprofile", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            cell.delegate = self;
            if defaults.object(forKey: "customerEmail") != nil{
                cell.profileEmail.text = defaults.object(forKey: "customerEmail") as? String
            }
            cell.profileEmail.isHidden = true
            if defaults.object(forKey: "customerName") != nil{
                cell.profileName.text = defaults.object(forKey: "customerName") as? String
            }
            cell.profileImage.image = UIImage(named: "ic_camera")!
            if defaults.object(forKey: "profilePicture") != nil{
                let imageUrl = defaults.object(forKey: "profilePicture") as? String
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl!, imageView: cell.profileImage)
            }
            if defaults.object(forKey: "profileBanner") != nil{
                let imageUrl = defaults.object(forKey: "profileBanner") as? String
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl!, imageView: cell.profileBannerImage)
            }
            cell.visualView.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
            print("isOwner:", defaults.object(forKey: "isOwner") as! String);
            if(defaults.object(forKey: "isOwner") as! String == "f") {
                cell.visualView.backgroundColor = UIColor(red: 29/255, green: 151/255, blue: 239/255, alpha: 1.0);
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.name.text = supplierProfileData[indexPath.row - 1] as! String
            cell.delegate = self;
            if didload != false{
                switch indexPath.row - 1 {
                case 0:
                    cell.nameValue.isHidden = true
                    cell.changeButton.isHidden = false
                    break
                case 1:
                    cell.nameValue.text = accountInfoModel.firstName
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.firstName;
                    break
                case 2:
                    cell.nameValue.text = accountInfoModel.lastName
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.lastName;
                    break
                case 3:
                    cell.nameValue.text = accountInfoModel.emailId
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.emailId;
                    break
                case 4:
                    cell.nameValue.text = accountInfoModel.mobileNumber
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.mobileNumber;
                    break
                case 5:
                    cell.nameValue.text = accountInfoModel.street
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.street;
                    break
                case 6:
                    cell.nameValue.text = accountInfoModel.city
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.city;
                    break
                case 7:
                    cell.nameValue.text = accountInfoModel.state
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.state;
                    break
                case 8:
                    cell.nameValue.text = accountInfoModel.postcode
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.postcode;
                    break
                    
                default:
                    cell.nameValue.text = accountInfoModel.country
                    self.supplierProfileDataValue[indexPath.row - 2] = accountInfoModel.country;
                    break
                    
                }
            }
            return cell
        }
    }
    
    func uploadProfilePic() {
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadpic"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraRollBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadfromcameraroll"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: {  })
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(clickBtn)
        AC.addAction(cameraRollBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(image, 0.5) as NSData!
            uploadImage = "true";
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    
    func uploadImageRequest(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false;
        let defaults = UserDefaults.standard;
        let customerId:String = (defaults.object(forKey:"customerId") as? String)!;
        uploadImage = ""
        var imageSendUrl:String = ""
        
        let url = "\(BASE_DOMAIN)/mobikulhttp/index/uploadProfilePic"
        imageSendUrl = url
       
        
        print(imageSendUrl)
        
        let request = NSMutableURLRequest(url: URL(string: imageSendUrl)!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let boundary = "unique-consistent-string"
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let body = NSMutableData()
        let screenWidth:String = String(format:"%f",SCREEN_WIDTH);
        
        // add params (all params are strings)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\("customerToken")\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(customerId)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\("width")\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(screenWidth)\r\n".data(using: String.Encoding.utf8)!)
        // add image data
        if (imageData != nil) {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\("imageFormKey"); filename=imageName.jpg\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData as Data)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "servererror"));
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions()) as (AnyObject)
                var dict = json as! [String:AnyObject];
                
                let imageUrl = dict["url"] as! String
                defaults.set(imageUrl, forKey: "profilePicture")
                self.profileTableView.reloadData()
            
                
                
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                
            } catch {
                print("json error: \(error)")
                
            }
            
        }
        
        task.resume()
        
    }
    
    func callingHttppApi(){
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.sync {
            GlobalData.sharedInstance.showLoader()
            if self.whichApiToProcess == "customerEditPost" && self.didload == true{
                var requstParams = [String:Any]();
                requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
                requstParams["websiteId"] = DEFAULT_WEBSITE_ID
                requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
                requstParams["firstName"] = self.supplierProfileDataValue[0];
                requstParams["secondName"] = self.supplierProfileDataValue[1];
                requstParams["email"] = self.supplierProfileDataValue[2];
                requstParams["phoneNumber"] = self.supplierProfileDataValue[3];
                requstParams["address"] = self.supplierProfileDataValue[4];
                requstParams["city"] = self.supplierProfileDataValue[5];
                requstParams["state"] = self.supplierProfileDataValue[6];
                requstParams["postCode"] = self.supplierProfileDataValue[7];
                requstParams["Country"] = self.supplierProfileDataValue[8];

                GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/saveAccountInfo", currentView: self){success,responseObject in
                    if success == 1{

                        GlobalData.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary
                        if dict.object(forKey: "success") as! Bool == true{
                            GlobalData.sharedInstance.showSuccessMessageWithBack(view: self,message:dict.object(forKey: "message") as! String )

                            let firstName = self.supplierProfileDataValue[0] as! String + " ";
                            let secondName = self.supplierProfileDataValue[1] as! String;
                            let name = firstName + secondName;
                            defaults.set(name, forKey: "customerName")
                            defaults.set(requstParams["email"] as! String, forKey: "customerEmail")
                            let city = requstParams["city"] as! String
                            let address = requstParams["address"] as! String + "," + city;
                            defaults.set(address, forKey: "address")
                            
                            if(defaults.object(forKey: "quoteId") != nil){
                                defaults.set(nil, forKey: "quoteId")
                                defaults.synchronize();
                            }
                            UserDefaults.standard.removeObject(forKey: "quoteId")
                            defaults.synchronize()
                            //self.navigationController?.popViewController(animated: true)
                        }else{
                            GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                            defaults.set(self.originalName, forKey: "customerName")
                            defaults.set(self.originalEmail, forKey: "customerEmail")
                        }

                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }else{
                var requstParams = [String:Any]();
                requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
                requstParams["websiteId"] = DEFAULT_WEBSITE_ID
                requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
                GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/accountInfoData", currentView: self){success,responseObject in
                    if success == 1{
                        
                        print((responseObject as! NSDictionary))
                        self.accountInfoModel  = AccountInformationModel(data: JSON(responseObject as! NSDictionary))
                        self.originalName = self.accountInfoModel.firstName + " " + self.accountInfoModel.lastName;
                        self.originalEmail = self.accountInfoModel.emailId;
                        self.doFurtherProcessingwithResult()
                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            
            }
            }
        });
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "editprofile") {
            let viewController:EditProfileViewController = segue.destination as UIViewController as! EditProfileViewController
            viewController.id = self.indexforcell;
            viewController.data = self.supplierProfileDataValue[self.indexforcell] as! String;
            if(self.indexforcell == 6) {
                //viewController.dataType = 2;
            } else if(self.indexforcell == 8) {
                viewController.dataType = 1;
            }
            viewController.countryData = self.accountInfoModel.countryData;
            viewController.placeholdString = self.supplierProfileData[self.indexforcell + 1] as! String;
            viewController.delegate = self;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (navigationController?.viewControllers.contains(self) == false)
        {
            self.whichApiToProcess = "customerEditPost";
            self.callingHttppApi();
        }
        super.viewWillDisappear(true)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
}

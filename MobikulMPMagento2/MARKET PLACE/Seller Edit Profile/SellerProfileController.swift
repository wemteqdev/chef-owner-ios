//
//  SellerProfileController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//





@objc protocol ColorPickerDelegate: class {
    func selectColorsValue(data:String)
}





import UIKit
import Alamofire

class SellerProfileController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ColorPickerDelegate {

var sellerEditProfileViewModel:SellerEditProfileViewModel!
@IBOutlet weak var twitterIdField: UITextField!
@IBOutlet weak var twitterSwitch: UISwitch!
@IBOutlet weak var facebookIdField: UITextField!
@IBOutlet weak var facebookSwitch: UISwitch!
@IBOutlet weak var instagramField: UITextField!
@IBOutlet weak var instagramSwitch: UISwitch!
@IBOutlet weak var googlePlusField: UITextField!
@IBOutlet weak var googlePlusswitch: UISwitch!
@IBOutlet weak var youtubeField: UITextField!
@IBOutlet weak var youtubeswitch: UISwitch!
@IBOutlet weak var vimeoField: UITextField!
@IBOutlet weak var vimeoswitch: UISwitch!
@IBOutlet weak var pinterestField: UITextField!
@IBOutlet weak var pinterestSwitch: UISwitch!
@IBOutlet weak var contactNumberField: UITextField!
@IBOutlet weak var taxVatField: UITextField!
@IBOutlet weak var themeFiled: UITextField!
@IBOutlet weak var shoptitleField: UITextField!
@IBOutlet weak var browseClick: UIButton!
@IBOutlet weak var companyBannerImage: UIImageView!
@IBOutlet weak var companyLogoImage: UIImageView!
@IBOutlet weak var companyLocalityField: UITextField!
@IBOutlet weak var comanyDescriptionField: UITextView!
@IBOutlet weak var returnPolicyField: UITextView!
@IBOutlet weak var shippingPolicyField: UITextView!
@IBOutlet weak var countryField: UITextField!
@IBOutlet weak var countryImage: UIImageView!
@IBOutlet weak var metaKeywordsField: UITextView!
@IBOutlet weak var metaDescriptionField: UITextView!
@IBOutlet weak var paymentInformation: UITextView!
@IBOutlet weak var SaveButton: UIButton!
var twitter:String = "0"
var facebook:String = "0"
var instagram:String = "0"
var googleplus:String = "0"
var youtube:String = "0"
var vimeo:String = "0"
var pinterest:String = "0"
var countryValue:String = ""
var currentImage:String = ""
var bannerImageData:NSData!
var profileImageData:NSData!
var whichApiToProcess:String = ""
var deleteImage:String = ""
let uploadUrl:String = HOST_NAME+"mobikulmphttp/marketplace/SaveProfile"
var headers: HTTPHeaders = [:]
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "editsellerprofile")
        SaveButton.setTitleColor(UIColor.white, for: .normal)
        SaveButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        SaveButton.setTitle(GlobalData.sharedInstance.language(key: "save"), for: .normal)
        if defaults.object(forKey: "authKey") == nil{
            headers = [
                "apiKey": API_USER_NAME,
                "apiPassword": API_KEY,
                "authKey":""
            ]
        }else{
            headers = [
                "apiKey": API_USER_NAME,
                "apiPassword": API_KEY,
                "authKey":defaults.object(forKey: "authKey") as! String
            ]
        }
        
        callingHttppApi()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    
    
    
    func selectColorsValue(data:String){
         themeFiled.text = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "colorpicker") {
            let viewController:ColorPickerController = segue.destination as UIViewController as! ColorPickerController
            viewController.delegate = self
        }
        
    }
    
    
   
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "deleteimage"{
            requstParams["entity"] = self.deleteImage
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/deleteSellerImage", currentView: self){success,responseObject in
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
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        else{
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/profileFormData", currentView: self){success,responseObject in
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
                    self.sellerEditProfileViewModel = SellerEditProfileViewModel(data:dict)
                    self.doFurtherWithData()
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                print("sss", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        }
        
    }
    
    
    @IBAction func twitterClick(_ sender: UISwitch) {
        if sender.isOn{
            twitter = "1"
        }else{
            twitter = "0"
        }
    }
    
  
    
    @IBAction func facebookClick(_ sender: UISwitch) {
        if sender.isOn{
            facebook = "1"
        }else{
            facebook = "0"
        }
    }
    
    
    
    
    @IBAction func instagramClick(_ sender: UISwitch) {
        if sender.isOn{
            instagram = "1"
        }else{
            instagram = "0"
        }
    }
    

    
    
    @IBAction func googlePlusClick(_ sender: UISwitch) {
        if sender.isOn{
            googleplus = "1"
        }else{
            googleplus = "0"
        }
    }
    
    
    
    @IBAction func youTubeClick(_ sender: UISwitch) {
        if sender.isOn{
            youtube = "1"
        }else{
            youtube = "0"
        }
    }
    
    
    
    @IBAction func vimeoClick(_ sender: UISwitch) {
        if sender.isOn{
            vimeo = "1"
        }else{
            vimeo = "0"
        }
    }
    

    @IBAction func pinterestClick(_ sender: UISwitch) {
        if sender.isOn{
            pinterest = "1"
        }else{
            pinterest = "0"
        }
    }
    
    @IBAction func pickColor(_ sender: UIButton) {
        self.performSegue(withIdentifier: "colorpicker", sender: self)
    }
    
    
    
    
    @IBAction func contactInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.contactNumberHint )
    }
    
    
    @IBAction func taxVatInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.taxvatHint )
    }
    
    
    @IBAction func themeInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.backgroundColorHint )
    }
    

    
    
    @IBAction func shopTitleInfoClick(_ sender: Any) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.shopTitleHint )
    }
    
    
    
    @IBAction func companyBannerInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.bannerHint )
    }
    
    
    @IBAction func companyLogoInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.profileImageHint )
    }
    
    
    @IBAction func clickComanyBannerImageSelection(_ sender: Any) {
        currentImage = "banner"
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadbanner"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture") , style: .default, handler: {(_ action: UIAlertAction) -> Void in
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
    
    
    @IBAction func comapnyLogoImageSelection(_ sender: UIButton) {
        currentImage = "profile"
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadbanner"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture") , style: .default, handler: {(_ action: UIAlertAction) -> Void in
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
    
    
    @IBAction func deleteComapnyBannerImage(_ sender: UIButton) {
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "pleaseconfirm"), message: GlobalData.sharedInstance.language(key: "deletebannerimage"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "deleteimage";
            self.deleteImage = "banner"
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
        
        
        
    }
    
    
    @IBAction func deleteComanyLogoImage(_ sender: UIButton) {
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "pleaseconfirm"), message: GlobalData.sharedInstance.language(key: "deletelogoimage"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "deleteimage";
            self.deleteImage = "logo"
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
        
    }
    
    
    @IBAction func companyLocalityInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.companyLocalityHint )
        
    }
    
    @IBAction func comanyDescriptionInfoClick(_ sender: UIButton) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.companyDescriptionHint )
    }
    
    
    @IBAction func returnPolicyInfoClick(_ sender: Any) {
         GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.returnPolicyHint )
    }
    
    
    
    @IBAction func shippingInfoClick(_ sender: Any) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.shippingPolicyHint )
    }
    
    
    @IBAction func countryInfoClick(_ sender: Any) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.countryHint )
    }
    
    
    @IBAction func countrySelectClick(_ sender: UITextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        countryField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    @IBAction func metaKeywordsInfoClick(_ sender: Any) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.metaKeywordHint )
    }
    
    
    @IBAction func metadescriptionInfoClick(_ sender: Any) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.metaDescriptionHint )
    }
    
    
    @IBAction func paymentInfoClick(_ sender: Any) {
        GlobalData.sharedInstance.showInfoSnackBar(msg:self.sellerEditProfileViewModel.sellerEditProfileData.paymentDetailsHint )
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.sellerEditProfileViewModel.sellerCountryData.count
        }else{
            return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            return self.sellerEditProfileViewModel.sellerCountryData[row].label
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            self.countryField.text = self.sellerEditProfileViewModel.sellerCountryData[row].label
            self.countryValue = self.sellerEditProfileViewModel.sellerCountryData[row].value
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerEditProfileViewModel.sellerEditProfileData.flagImageUrl+"/"+self.countryValue+".png", imageView: countryImage)
            
            
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if currentImage == "banner"{
            bannerImageData = UIImageJPEGRepresentation(image, 0.5) as NSData!
            companyBannerImage.image = image
            }else{
            profileImageData = UIImageJPEGRepresentation(image, 0.5) as NSData!
            companyLogoImage.image = image
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func doFurtherWithData(){
        self.twitterIdField.text = self.sellerEditProfileViewModel.sellerEditProfileData.twitterId
        self.facebookIdField.text = self.sellerEditProfileViewModel.sellerEditProfileData.facebookId
        self.instagramField.text = self.sellerEditProfileViewModel.sellerEditProfileData.instagramId
        self.googlePlusField.text = self.sellerEditProfileViewModel.sellerEditProfileData.googleplusId
        self.youtubeField.text = self.sellerEditProfileViewModel.sellerEditProfileData.youtubeId
        self.vimeoField.text = self.sellerEditProfileViewModel.sellerEditProfileData.vimeoId
        self.pinterestField.text = self.sellerEditProfileViewModel.sellerEditProfileData.pinterestId
        self.contactNumberField.text = self.sellerEditProfileViewModel.sellerEditProfileData.contactNumber
        self.taxVatField.text = self.sellerEditProfileViewModel.sellerEditProfileData.taxvat
        self.themeFiled.text = self.sellerEditProfileViewModel.sellerEditProfileData.backgroundColor
        self.shoptitleField.text = self.sellerEditProfileViewModel.sellerEditProfileData.shopTitle
        self.companyLocalityField.text = self.sellerEditProfileViewModel.sellerEditProfileData.companyLocality
        self.comanyDescriptionField.text = self.sellerEditProfileViewModel.sellerEditProfileData.companyDescription
        self.returnPolicyField.text = self.sellerEditProfileViewModel.sellerEditProfileData.returnPolicy
        self.shippingPolicyField.text = self.sellerEditProfileViewModel.sellerEditProfileData.shippingPolicy
        self.metaKeywordsField.text = self.sellerEditProfileViewModel.sellerEditProfileData.metaKeyword
        self.metaDescriptionField.text = self.sellerEditProfileViewModel.sellerEditProfileData.metaDescription
        self.paymentInformation.text = self.sellerEditProfileViewModel.sellerEditProfileData.paymentDetails
        
        
        if self.sellerEditProfileViewModel.sellerEditProfileData.isTwitterActive == true{
            twitterSwitch.isOn = true;
            twitter = "1"
        }
        if self.sellerEditProfileViewModel.sellerEditProfileData.isFacebookActive == true{
            facebookSwitch.isOn = true;
            facebook = "1"
        }
        if self.sellerEditProfileViewModel.sellerEditProfileData.isInstagramActive == true{
            instagramSwitch.isOn = true;
            instagram = "1"
        }
        if self.sellerEditProfileViewModel.sellerEditProfileData.isgoogleplusActive == true{
            googlePlusswitch.isOn = true;
            googleplus = "1"
        }
        if self.sellerEditProfileViewModel.sellerEditProfileData.isYoutubeActive == true{
            youtubeswitch.isOn = true;
            youtube = "1"
        }
        if self.sellerEditProfileViewModel.sellerEditProfileData.isVimeoActive == true{
            vimeoswitch.isOn = true;
            vimeo = "1"
        }
        if self.sellerEditProfileViewModel.sellerEditProfileData.isPinterestActive == true{
            pinterestSwitch.isOn = true;
            pinterest = "1"
        }
        
        
        for i in 0..<self.sellerEditProfileViewModel.sellerCountryData.count{
            if self.sellerEditProfileViewModel.sellerCountryData[i].value == self.sellerEditProfileViewModel.sellerEditProfileData.country{
                self.countryField.text = self.sellerEditProfileViewModel.sellerCountryData[i].label
                self.countryValue = self.sellerEditProfileViewModel.sellerEditProfileData.country
                break;
            }
        }
        
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerEditProfileViewModel.sellerEditProfileData.bannerImage, imageView: companyBannerImage)
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerEditProfileViewModel.sellerEditProfileData.profileImage, imageView: companyLogoImage)
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerEditProfileViewModel.sellerEditProfileData.flagImageUrl+"/"+self.sellerEditProfileViewModel.sellerEditProfileData.country+".png", imageView: countryImage)
        
        
        
    }
    
    
    
    
    
    
    func saveProfileData(){
        DispatchQueue.main.async {
            Alamofire.upload(multipartFormData: { multipartFormData in
                let customerId = defaults.object(forKey:"customerId");
                var params = [String:AnyObject]();
                
                let storeId = defaults.object(forKey: "storeId")
                if(storeId != nil){
                    params["storeId"] = storeId as AnyObject
                }
                params["customerToken"] = customerId as AnyObject
                params["twActive"] = self.twitter as AnyObject as AnyObject
                params["twitterId"] = self.twitterIdField.text as AnyObject
                params["fbActive"] = self.facebook as AnyObject
                params["facebookId"] = self.facebookIdField.text as AnyObject
                params["instagramActive"] = self.instagram as AnyObject
                params["instagramId"] = self.instagramField.text as AnyObject
                params["gplusActive" ] = self.googleplus as AnyObject
                params["gplusId"] = self.googlePlusField.text as AnyObject
               params["youtubeActive"] = self.youtube as AnyObject
               params["youtubeId"] = self.youtubeField.text as AnyObject
                params["vimeoActive"] = self.vimeo as AnyObject
                params["vimeoId"] = self.vimeoField.text as AnyObject
                params["pinterestActive"] = self.pinterest as AnyObject
                params["pinterestId"] = self.pinterestField.text as AnyObject
                params["contactNumber"] = self.contactNumberField.text as AnyObject
                params["taxvat"] = self.taxVatField.text as AnyObject
                params["backgroundColor"] = self.themeFiled.text as AnyObject
                params["shopTitle"] = self.shoptitleField.text as AnyObject
                
                params["companyLocality"] = self.companyLocalityField.text as AnyObject
                params["companyDescription"] = self.comanyDescriptionField.text as AnyObject
                params["returnPolicy" ] = self.returnPolicyField.text as AnyObject
                params["shippingPolicy"] = self.shippingPolicyField.text as AnyObject
                params["country"] = self.countryValue as AnyObject
                params["metaKeyword"] = self.metaKeywordsField.text as AnyObject
                params["metaDescription"] = self.metaDescriptionField.text as AnyObject
                params["paymentDetails"] = self.paymentInformation.text as AnyObject
                
                
                
                print(params)
                for (key, value) in params {
                    if let data = value.data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                        
                    }
                }
                
                
              
                if self.profileImageData != nil{
                    let imageData1 = self.profileImageData! as Data
                    multipartFormData.append(imageData1, withName: "logo", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                if self.bannerImageData != nil{
                    let imageData1 = self.bannerImageData! as Data
                     multipartFormData.append(imageData1, withName: "banner", fileName: "image.jpg", mimeType: "image/jpeg")
                }

                
            },
                             to: self.uploadUrl,method:HTTPMethod.post,
                             headers:self.headers, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload
                                        .validate()
                                        .responseJSON { response in
                                            switch response.result {
                                            case .success(let value):
                                                print("responseObject: \(value)")
                                                var dict = JSON(value)
                                                GlobalData.sharedInstance.showSuccessSnackBar(msg:dict["message"].stringValue )
                                                GlobalData.sharedInstance.dismissLoader()
                                                
                                            case .failure(let responseError):
                                                GlobalData.sharedInstance.showErrorSnackBar(msg: "Not updated")
                                                GlobalData.sharedInstance.dismissLoader()
                                                print("responseError: \(responseError)")
                                            }
                                    }
                                case .failure(let encodingError):
                                    print("encodingError: \(encodingError)")
                                }
            })
            
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func saveClick(_ sender: Any) {
        GlobalData.sharedInstance.showLoader()
        self.saveProfileData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

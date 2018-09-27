//
//  AddProductController.swift
//  ShangMarket
//
//  Created by kunal on 23/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import Alamofire

class AddProductController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    var productId:String = ""
    var addproductViewModel:AddproductViewModel!
    @IBOutlet weak var selectCategoryButton: UIButton!
    var categorySectionName:NSMutableArray = []
    var categorySectionId:NSMutableArray = []
    var categorySectionChildArray :NSMutableArray = [];
    var categorySectionChildId:NSMutableArray = [];
    var selectedCategoryIdFromServer:NSMutableArray = []
    
    var assignedCategoriesFromServer:NSMutableArray = []
    var assignedCategories : Bool = false
    
    var tempArray:NSMutableArray = []
    var tempIdArray:NSMutableArray = []
    
    @IBOutlet weak var attributeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var productTypeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var productNametextField: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var shortdescriptionLabel: UILabel!
    @IBOutlet weak var shortDescriptionField: UITextView!
    @IBOutlet weak var skuTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var pricetextField: SkyFloatingLabelTextField!
    @IBOutlet weak var specialPricetextField: SkyFloatingLabelTextField!
    @IBOutlet weak var specialpriceFromTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var specialPriceToTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stockTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var stockAvailabilityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var visibilityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var taxClassesField: SkyFloatingLabelTextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var metaTitleField: SkyFloatingLabelTextField!
    @IBOutlet weak var metaKeyWordLabel: UILabel!
    @IBOutlet weak var metaKeyWordField: UITextView!
    @IBOutlet weak var metaDescriptionLabel: UILabel!
    @IBOutlet weak var metadescriptionField: UITextView!
    
    var taxableOptionData:NSMutableArray = []
    @IBOutlet weak var saveButton: UIButton!
    
    var attributeSetId:String = ""
    var productType:String = ""
    var stockAvailableValue:Int = 1
    var visiblityValue:String = ""
    var taxClassesValue:String = ""
    var isWeight:String = "1"
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var relatedproductLabel: UILabel!
    @IBOutlet weak var upsellproductlabel: UILabel!
    @IBOutlet weak var crosssellproductlabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    var image1Flag:Bool = false
    var image2Flag:Bool = false
    var image3Flag:Bool = false
    var image4Flag:Bool = false
    var imageData:NSData!
    var fileName:String = ""
    
    @IBOutlet weak var cartLimitField: SkyFloatingLabelTextField!
    @IBOutlet weak var weightSwitch: UISwitch!
    
    let uploadUrl:String = HOST_NAME+"mobikulmphttp/product/UploadProductImage"
    var headers: HTTPHeaders = [:]
    var productImageGalleryDict = [String:String]()
    var productImageGalleryValueIDDict = [String:String]()
    var whichApiToprocess:String = ""
    var websieIDs:NSMutableArray = [];
    var isProductEdit:Bool = false
    
    var deleteImgArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if productId == ""  {
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "addproduct")
        }else{
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "editproduct")
        }
        
        self.callingHttppApi()
        
        attributeTextField.placeholder = GlobalData.sharedInstance.language(key: "attributeset")
        productTypeTextField.placeholder = GlobalData.sharedInstance.language(key: "producttype")
        selectCategoryButton.setTitle(GlobalData.sharedInstance.language(key: "selectcategory"), for: .normal)
        selectCategoryButton.setTitleColor(UIColor.white, for: .normal)
        selectCategoryButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        productNametextField.placeholder = GlobalData.sharedInstance.language(key: "productname")+" "+GlobalData.sharedInstance.language(key: "required")
        descriptionLabel.text = GlobalData.sharedInstance.language(key: "description")+" "+GlobalData.sharedInstance.language(key: "required")
        shortdescriptionLabel.text = GlobalData.sharedInstance.language(key: "shortdescription")
        
        skuTextField.placeholder = GlobalData.sharedInstance.language(key: "sku")+" "+GlobalData.sharedInstance.language(key: "required")
        
        pricetextField.placeholder = GlobalData.sharedInstance.language(key: "price")+" "+GlobalData.sharedInstance.language(key: "required")
        
        specialPricetextField.placeholder = GlobalData.sharedInstance.language(key: "specialprice")
        
        
        specialpriceFromTextField.placeholder = GlobalData.sharedInstance.language(key: "specialpricefrom")
        
        
        specialPriceToTextField.placeholder = GlobalData.sharedInstance.language(key: "specialpriceto")
        
        stockTextField.placeholder = GlobalData.sharedInstance.language(key: "stock")+" "+GlobalData.sharedInstance.language(key: "required")
        
        stockAvailabilityTextField.placeholder = GlobalData.sharedInstance.language(key: "stockavailable")+" "+GlobalData.sharedInstance.language(key: "required")
        visibilityTextField.placeholder = GlobalData.sharedInstance.language(key: "visibility")+" "+GlobalData.sharedInstance.language(key: "required")
        taxClassesField.placeholder = GlobalData.sharedInstance.language(key: "taxclasses")+" "+GlobalData.sharedInstance.language(key: "required")
        
        weightLabel.text = GlobalData.sharedInstance.language(key: "weight")+" "+GlobalData.sharedInstance.language(key: "required")
        metaTitleField.placeholder = GlobalData.sharedInstance.language(key: "metatitle")
        
        metaKeyWordLabel.text = GlobalData.sharedInstance.language(key: "metakeyword")
        metaDescriptionLabel.text = GlobalData.sharedInstance.language(key: "metadescription")
        
        saveButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitle(GlobalData.sharedInstance.language(key: "save"), for: .normal)
        saveButton.layer.cornerRadius = 5.0
        saveButton.layer.masksToBounds = true
        relatedproductLabel.text = GlobalData.sharedInstance.language(key: "relatedproduct")
        upsellproductlabel.text = GlobalData.sharedInstance.language(key: "upsellproducts")
        crosssellproductlabel.text = GlobalData.sharedInstance.language(key: "crosssellproducts")
        
        let imageTap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageUpload1function))
        image1.addGestureRecognizer(imageTap1)
        
        let imageTap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageUpload2function))
        image2.addGestureRecognizer(imageTap2)
        let imageTap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageUpload3function))
        image3.addGestureRecognizer(imageTap3)
        let imageTap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageUpload4function))
        image4.addGestureRecognizer(imageTap4)
        
        let view1Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addRelatedproduct))
        view1.addGestureRecognizer(view1Tap)
        
        let view2Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addUpSellproduct))
        view2.addGestureRecognizer(view2Tap)
        
        let view3Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCrossSellproduct))
        view3.addGestureRecognizer(view3Tap)
        
        
        
        image2.isHidden = true;
        image3.isHidden = true
        image4.isHidden = true
        
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
        
        view1.backgroundColor  = UIColor.white
        view1.layer.borderWidth = 0.5
        view2.backgroundColor  = UIColor.white
        view2.layer.borderWidth = 0.5
        view3.backgroundColor  = UIColor.white
        view3.layer.borderWidth = 0.5
        
        relatedproductLabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        crosssellproductlabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        upsellproductlabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        cartLimitField.isHidden = true;
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true;
        
        GlobalVariables.selectedRelatedProductIds = []
        GlobalVariables.selectedCategoryIds = []
        GlobalVariables.selectedUPSellProductIds = []
        GlobalVariables.selectedCrossSellProductIds = []
        
        taxableOptionData.add("None");
        taxClassesField.text = taxableOptionData[0] as? String
        taxClassesValue = "0"
    }
    
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    @objc func imageUpload1function() {
        fileName = "image1";
        self.imageuploadOption()
    }
    
    @objc func imageUpload2function() {
        fileName = "image2";
        self.imageuploadOption()
    }
    @objc func imageUpload3function() {
        fileName = "image3";
        self.imageuploadOption()
    }
    @objc func imageUpload4function() {
        fileName = "image4";
        self.imageuploadOption()
    }
    
    @objc func addRelatedproduct() {
        self.performSegue(withIdentifier: "relatedproduct", sender: self)
    }
    
    @objc func addUpSellproduct() {
        self.performSegue(withIdentifier: "upsell", sender: self)
    }
    
    @objc func addCrossSellproduct() {
        self.performSegue(withIdentifier: "crosssell", sender: self)
    }
    
    @IBAction func skuValueChangedClick(_ sender: SkyFloatingLabelTextField) {
        var requstParams = [String:Any]();
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        
        requstParams["sku"] = sender.text
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/product/checkSku", currentView: self){success,responseObject in
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
                if dict["availability"].intValue == 1{
                    
                }else{
                    self.skuTextField.text = ""
                }
                
                print("sss", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func imageuploadOption() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let img1 = image.fixOrientation()
            imageData = UIImageJPEGRepresentation(img1, 0.5) as NSData!
            self.saveProfileData(fileName: fileName)
            if fileName == "image1"{
                image1.image = img1
                image2.isHidden = false
                
                if productImageGalleryValueIDDict["image1_id"] != nil && productImageGalleryValueIDDict["image1_id"] != ""  {
                    deleteImgArr.append(productImageGalleryValueIDDict["image1_id"]!)
                }
                
                productImageGalleryValueIDDict["image1_id"] = ""
            }else if fileName == "image2"{
                image2.image = img1
                image3.isHidden = false
                
                if productImageGalleryValueIDDict["image2_id"] != nil && productImageGalleryValueIDDict["image2_id"] != ""  {
                    deleteImgArr.append(productImageGalleryValueIDDict["image2_id"]!)
                }
                
                productImageGalleryValueIDDict["image2_id"] = ""
            }else if fileName == "image3"{
                image3.image = img1
                image4.isHidden = false
                
                if productImageGalleryValueIDDict["image3_id"] != nil && productImageGalleryValueIDDict["image3_id"] != ""  {
                    deleteImgArr.append(productImageGalleryValueIDDict["image3_id"]!)
                }
                
                productImageGalleryValueIDDict["image3_id"] = ""
            }else if fileName == "image4"{
                image4.image = img1
                
                if productImageGalleryValueIDDict["image4_id"] != nil && productImageGalleryValueIDDict["image4_id"] != ""  {
                    deleteImgArr.append(productImageGalleryValueIDDict["image4_id"]!)
                }
                
                productImageGalleryValueIDDict["image4_id"] = ""
            }
        }
        
        picker.dismiss(animated: true, completion: nil);
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
        
        if whichApiToprocess == "saveproduct"{
            requstParams["type"] = productType
            requstParams["productId"] = self.productId
            requstParams["status"] = "1"
            requstParams["attributeSetId"] = attributeSetId
            requstParams["name"] = productNametextField.text
            requstParams["description"] = descriptionField.text
            requstParams["shortDescription"] = shortDescriptionField.text
            requstParams["sku"] = skuTextField.text
            requstParams["price"] = pricetextField.text
            requstParams["specialPrice"] = specialPricetextField.text
            requstParams["specialFromDate"] = specialpriceFromTextField.text
            requstParams["specialToDate"] = specialPriceToTextField.text
            requstParams["qty"] = stockTextField.text
            requstParams["isInStock"] = stockAvailableValue
            requstParams["visibility"] = visiblityValue
            requstParams["taxClassId"] = taxClassesValue
            requstParams["productHasWeight"] = isWeight
            requstParams["weight"] = weightField.text
            requstParams["metaTitle"] = metaTitleField.text
            requstParams["metaKeyword"] = metaKeyWordField.text
            requstParams["metaDescription"] = metadescriptionField.text
            if addproductViewModel.extraAddProductData.addProductLimitStatus == 1{
                requstParams["mpProductCartLimit"] = cartLimitField.text
            }
            
            if self.productImageGalleryDict["image1"] !=  nil{
                requstParams["baseImage"] = self.productImageGalleryDict["image1"]
                requstParams["smallImage"] = self.productImageGalleryDict["image1"]
                requstParams["swatchImage"] = self.productImageGalleryDict["image1"]
                requstParams["thumbnail"] = self.productImageGalleryDict["image1"]
            }
            
            var mediaImageGallery = [String:AnyObject]()
            
            if self.productImageGalleryDict["image1"] !=  nil{
                var dummy = [String:String]()
                dummy["position"] = "1";
                dummy["file"] = self.productImageGalleryDict["image1"]
                dummy["disabled"] = "0"
                dummy["value_id"] = self.productImageGalleryValueIDDict["image1_id"]
                mediaImageGallery["0"] = dummy as AnyObject
            }
            if self.productImageGalleryDict["image2"] !=  nil{
                var dummy = [String:String]()
                dummy["position"] = "2";
                dummy["file"] = self.productImageGalleryDict["image2"];
                dummy["disabled"] = "0"
                dummy["value_id"] = self.productImageGalleryValueIDDict["image2_id"]
                mediaImageGallery["1"] = dummy as AnyObject
            }
            if self.productImageGalleryDict["image3"] !=  nil{
                var dummy = [String:String]()
                dummy["position"] = "3";
                dummy["file"] = self.productImageGalleryDict["image3"];
                dummy["disabled"] = "0"
                dummy["value_id"] = self.productImageGalleryValueIDDict["image3_id"]
                mediaImageGallery["2"] = dummy as AnyObject
            }
            if self.productImageGalleryDict["image4"] !=  nil{
                var dummy = [String:String]()
                dummy["position"] = "4";
                dummy["file"] = self.productImageGalleryDict["image4"];
                dummy["disabled"] = "0"
                dummy["value_id"] = self.productImageGalleryValueIDDict["image4_id"]
                mediaImageGallery["3"] = dummy as AnyObject
            }
            
            requstParams["deleteImageId"] = deleteImgArr.joined(separator: ",")
            
            do {
                let jsonCategoriesData =  try JSONSerialization.data(withJSONObject: GlobalVariables.selectedCategoryIds, options: .prettyPrinted)
                let jsonCategoryString:String = NSString(data: jsonCategoriesData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["categoryIds"] = jsonCategoryString
                
                let jsonWebsiteIdData =  try JSONSerialization.data(withJSONObject: websieIDs, options: .prettyPrinted)
                let jsonWebsiteIdString:String = NSString(data: jsonWebsiteIdData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["websiteIds"] = jsonWebsiteIdString
                
                let jsonMediaGalleryData =  try JSONSerialization.data(withJSONObject: mediaImageGallery, options: .prettyPrinted)
                let jsonMediaGalleryString:String = NSString(data: jsonMediaGalleryData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["medialGallery"] = jsonMediaGalleryString
                
                let jsonRelatedProductData =  try JSONSerialization.data(withJSONObject: GlobalVariables.selectedRelatedProductIds, options: .prettyPrinted)
                let jsonRelatedProductString:String = NSString(data: jsonRelatedProductData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["related"] = jsonRelatedProductString
                
                let jsonUpsellProductData =  try JSONSerialization.data(withJSONObject: GlobalVariables.selectedUPSellProductIds, options: .prettyPrinted)
                let jsonUpsellProductString:String = NSString(data: jsonUpsellProductData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["upsell"] = jsonUpsellProductString
                
                
                let jsonCrosssellProductData =  try JSONSerialization.data(withJSONObject: GlobalVariables.selectedCrossSellProductIds, options: .prettyPrinted)
                let jsonCrossSellProductString:String = NSString(data: jsonCrosssellProductData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["crossSell"] = jsonCrossSellProductString
            }
            catch {
                print(error.localizedDescription)
            }
            
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/product/SaveProduct", currentView: self){success,responseObject in
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
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        GlobalData.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        else{
            requstParams["productId"] = self.productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/product/newformdata", currentView: self){success,responseObject in
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
                    self.addproductViewModel = AddproductViewModel(data:dict)
                    self.doFurtherWithData(dict: dict)
                    
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    @IBAction func clickOnselectCategory(_ sender: UIButton) {
        self.performSegue(withIdentifier: "selectCategorySegue", sender: self)
    }
    
    
    func performRecursion(data:JSON,level:Int,pos:Int){
        var childDict:JSON!
        for i in 0..<data["children"].count{
            childDict = data["children"][i]
            let spaces = String(repeating: "   ", count: level*2)
            tempArray.add(spaces+childDict["name"].string!)
            tempIdArray.add(childDict["category_id"].string!)
            categorySectionChildArray[pos] = tempArray
            categorySectionChildId[pos] = tempIdArray;
            if childDict["children"].count > 0{
                performRecursion(data: childDict,level: level + 1,pos:pos)
            }
        }
    }
    
    func doFurtherWithData(dict:JSON){
        
        //select category case
        if dict["categories"].count > 0 {
            
            assignedCategories = false
            
            for i in 0..<dict["categories"]["children"].count {
                var childDict = dict["categories"]["children"][i];
                self.categorySectionName.add(childDict["name"].stringValue);
                self.categorySectionId.add(childDict["category_id"].stringValue)
                
                if childDict["children"].count > 0{
                    self.tempArray = []
                    self.tempIdArray = []
                    self.performRecursion(data:childDict,level: 1,pos:i)
                }else{
                    self.tempArray = [];
                    self.tempIdArray = []
                    self.categorySectionChildArray[i] = self.tempArray;
                    self.categorySectionChildId[i] = self.tempIdArray
                }
            }
        }else{
            assignedCategories = true
            
            if (dict["assignedCategories"].arrayObject?.count)! > 0    {
                self.assignedCategoriesFromServer = NSMutableArray(array: dict["assignedCategories"].arrayObject!)
            }
        }
        
        
        if addproductViewModel.extraAddProductData.addRelatedProductStatus == 1{
            view1.isHidden = false
        }
        if addproductViewModel.extraAddProductData.addUpsellProductStatus == 1{
            view2.isHidden = false
        }
        if addproductViewModel.extraAddProductData.addCrosssellProductStatus == 1{
            view3.isHidden = false
        }
        
        
        if  addproductViewModel.taxOptions.count > 0{
            for i in 0..<addproductViewModel.taxOptions.count{
                taxableOptionData.add(addproductViewModel.taxOptions[i].label)
            }
        }
        
        /////////////////////////////////////////////////////////////////////////////////////////////
        
        
        if !isProductEdit{
            if addproductViewModel.allowedAttributesData.count > 0{
                attributeTextField.text = addproductViewModel.allowedAttributesData[0].label
                attributeSetId = addproductViewModel.allowedAttributesData[0].value
            }
            if addproductViewModel.allowedTypes.count > 0{
                productTypeTextField.text = addproductViewModel.allowedTypes[0].label
                productType = addproductViewModel.allowedTypes[0].value
            }
            if addproductViewModel.inventoryAvailabilityOptions.count > 0{
                stockAvailabilityTextField.text = addproductViewModel.inventoryAvailabilityOptions[0].label
                stockAvailableValue = addproductViewModel.inventoryAvailabilityOptions[0].value
            }
            
            if addproductViewModel.visibilityOptions.count > 0{
                visibilityTextField.text = addproductViewModel.visibilityOptions[0].label
                visiblityValue = addproductViewModel.visibilityOptions[0].value
            }
            
            if addproductViewModel.extraAddProductData.skutype != "static"{
                skuTextField.isHidden = true;
            }
            
            
            if addproductViewModel.extraAddProductData.addProductLimitStatus == 1{
                cartLimitField.isHidden = false
            }
        }else{
            
            
            let receiveAttributeId = dict["productData"]["attributeSetId"].stringValue
            if addproductViewModel.allowedAttributesData.count > 0{
                for i in 0..<addproductViewModel.allowedAttributesData.count{
                    if receiveAttributeId == addproductViewModel.allowedAttributesData[i].value{
                        attributeTextField.text = addproductViewModel.allowedAttributesData[i].label
                        attributeSetId = addproductViewModel.allowedAttributesData[i].value
                        break;
                    }
                }
            }
            
            let selectedCategoryId:NSMutableArray = []
            for i in 0..<dict["productData"]["categoryIds"].count{
                selectedCategoryId.add(dict["productData"]["categoryIds"][i].stringValue)
            }
            GlobalVariables.selectedCategoryIds = selectedCategoryId
            
            let selectedCrossSellproduct:NSMutableArray = []
            for i in 0..<dict["productData"]["crossSell"].count{
                selectedCrossSellproduct.add(dict["productData"]["crossSell"][i].stringValue)
            }
            GlobalVariables.selectedCrossSellProductIds = selectedCrossSellproduct
            
            let selectedRelatedProductId:NSMutableArray = []
            for i in 0..<dict["productData"]["related"].count{
                selectedRelatedProductId.add(dict["productData"]["related"][i].stringValue)
            }
            GlobalVariables.selectedRelatedProductIds = selectedRelatedProductId
            
            
            let selectedUpSellProductId:NSMutableArray = []
            for i in 0..<dict["productData"]["upsell"].count{
                selectedUpSellProductId.add(dict["productData"]["upsell"][i].stringValue)
            }
            GlobalVariables.selectedUPSellProductIds = selectedUpSellProductId
            
            
            
            productType = dict["productData"]["type"].stringValue
            if addproductViewModel.allowedTypes.count > 0{
                for i in 0..<addproductViewModel.allowedTypes.count{
                    if productType == addproductViewModel.allowedTypes[i].value{
                        productTypeTextField.text = addproductViewModel.allowedTypes[i].label
                        break;
                    }
                }
            }
            
            weightField.text = dict["productData"]["weight"].stringValue
            
            visiblityValue = dict["productData"]["visibility"].stringValue
            if addproductViewModel.visibilityOptions.count > 0{
                for i in 0..<addproductViewModel.visibilityOptions.count{
                    if visiblityValue == addproductViewModel.visibilityOptions[i].value{
                        visibilityTextField.text = addproductViewModel.visibilityOptions[i].label
                        break;
                    }
                }
            }else{
                visibilityTextField.text = "None"
            }
            
            for i in 0..<dict["productData"]["websiteIds"].count{
                websieIDs.add(dict["productData"]["websiteIds"][i].stringValue)
            }
            
            taxClassesValue = dict["productData"]["taxClassId"].stringValue
            if taxClassesValue == "0"{
                taxClassesField.text = "None"
            }else{
                for i in 0..<addproductViewModel.taxOptions.count{
                    if taxClassesValue == addproductViewModel.taxOptions[i].value{
                        taxClassesField.text = addproductViewModel.taxOptions[i].label
                        break;
                    }
                }
            }
            
            specialPriceToTextField.text = dict["productData"]["specialToDate"].stringValue
            specialPricetextField.text = dict["productData"]["specialPrice"].stringValue
            specialpriceFromTextField.text = dict["productData"]["specialFromDate"].stringValue
            skuTextField.text = dict["productData"]["sku"].stringValue
            shortDescriptionField.text = dict["productData"]["shortDescription"].stringValue
            stockTextField.text = dict["productData"]["qty"].stringValue
            if dict["productData"]["productHasWeight"].intValue == 1{
                weightSwitch.setOn(true, animated: true)
                isWeight = "1"
            }else{
                weightSwitch.setOn(false, animated: true)
                isWeight = "0"
            }
            
            pricetextField.text = dict["productData"]["price"].stringValue
            productNametextField.text = dict["productData"]["name"].stringValue
            cartLimitField.text = dict["productData"]["mpProductCartLimit"].stringValue
            metaTitleField.text = dict["productData"]["metaTitle"].stringValue
            metaKeyWordField.text = dict["productData"]["metaKeyword"].stringValue
            metadescriptionField.text = dict["productData"]["metaDescription"].stringValue
            
            stockAvailableValue = dict["productData"]["isInStock"].intValue
            if addproductViewModel.inventoryAvailabilityOptions.count > 0{
                for i in 0..<addproductViewModel.inventoryAvailabilityOptions.count{
                    if stockAvailableValue == addproductViewModel.inventoryAvailabilityOptions[i].value{
                        stockAvailabilityTextField.text = addproductViewModel.inventoryAvailabilityOptions[i].label
                        break;
                    }}
            }
            
            descriptionField.text = dict["productData"]["description"].stringValue
            
            // image work
            
            let baseImage =  dict["productData"]["baseImage"].stringValue
            if baseImage != ""{
                productImageGalleryDict["image1"] = baseImage
            }
            
            let remainingImageArray:NSMutableArray = []
            for i in 0..<dict["productData"]["medialGallery"].count{
                var dict = dict["productData"]["medialGallery"][i];
                var remainingImagesDict = [String:String]()
                if dict["file"].stringValue != baseImage{
                    remainingImagesDict["file"] = dict["file"].stringValue
                    remainingImagesDict["id"] = dict["id"].stringValue
                    remainingImagesDict["entity_id"] = dict["entity_id"].stringValue
                    remainingImagesDict["url"] = dict["url"].stringValue
                    remainingImageArray.add(remainingImagesDict)
                }else{
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: dict["url"].stringValue, imageView: image1)
                    productImageGalleryValueIDDict["image1_id"] = dict["id"].stringValue
                    image2.isHidden = false
                }
            }
            
            for i in 0..<remainingImageArray.count{
                var dict = remainingImageArray[i] as! [String:String];
                if i == 0{
                    image3.isHidden = false;
                    productImageGalleryDict["image2"] = dict["file"]
                    productImageGalleryValueIDDict["image2_id"] = dict["id"]!
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: dict["url"]!, imageView: image2)
                }
                else  if i == 1{
                    image4.isHidden = false;
                    productImageGalleryDict["image3"] = dict["file"]
                    productImageGalleryValueIDDict["image3_id"] = dict["id"]!
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: dict["url"]!, imageView: image3)
                }
                    
                else  if i == 2{
                    productImageGalleryDict["image4"] = dict["file"]
                    productImageGalleryValueIDDict["image4_id"] = dict["id"]!
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: dict["url"]!, imageView: image4)
                }
            }
        }
    }
    
    @IBAction func AttributeSetClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        attributeTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func ProducTypeClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 2000;
        productTypeTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    @IBAction func specialPriceFromClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        specialpriceFromTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddProductController.datePickerfromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerfromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        specialpriceFromTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func specialPriceToClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        specialPriceToTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddProductController.datePickerToValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        specialPriceToTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func stockAvailabilityClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000;
        stockAvailabilityTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func visibilityClick(_ sender: SkyFloatingLabelTextField) {
        
        let thePicker = UIPickerView()
        thePicker.tag = 4000
        visibilityTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func TaxClassesClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 5000;
        taxClassesField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func weghtClick(_ sender: UISwitch) {
        if sender.isOn{
            weightField.isEnabled = true
            isWeight = "1"
        }else{
            weightField.isEnabled =  false
            isWeight = "0"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.addproductViewModel.allowedAttributesData.count
        }else if(pickerView.tag == 2000){
            return self.addproductViewModel.allowedTypes.count
        }else if(pickerView.tag == 3000){
            return self.addproductViewModel.inventoryAvailabilityOptions.count
        }else if(pickerView.tag == 4000){
            return self.addproductViewModel.visibilityOptions.count
        }else if(pickerView.tag == 5000){
            return taxableOptionData.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            return self.addproductViewModel.allowedAttributesData[row].label
        }else if(pickerView.tag == 2000){
            return self.addproductViewModel.allowedTypes[row].label
        }else if(pickerView.tag == 3000){
            return self.addproductViewModel.inventoryAvailabilityOptions[row].label
        }else if(pickerView.tag == 4000){
            if self.addproductViewModel.visibilityOptions.count > 0 {
                return self.addproductViewModel.visibilityOptions[row].label
            }else{
                return ""
            }
        }else if(pickerView.tag == 4000){
            return self.taxableOptionData[row] as? String
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if  pickerView.tag == 1000{
            attributeTextField.text = self.addproductViewModel.allowedAttributesData.count > 0 ? self.addproductViewModel.allowedAttributesData[row].label : ""
            attributeSetId = self.addproductViewModel.allowedAttributesData.count > 0 ? self.addproductViewModel.allowedAttributesData[row].value : ""
        }else if(pickerView.tag == 2000){
            productTypeTextField.text = self.addproductViewModel.allowedTypes.count > 0 ? self.addproductViewModel.allowedTypes[row].label : ""
            productType = self.addproductViewModel.allowedTypes.count > 0 ? self.addproductViewModel.allowedTypes[row].value : ""
        }else if(pickerView.tag == 3000){
            stockAvailabilityTextField.text = self.addproductViewModel.inventoryAvailabilityOptions[row].label
            stockAvailableValue = self.addproductViewModel.inventoryAvailabilityOptions[row].value
        }else if(pickerView.tag == 4000){
            
            if self.addproductViewModel.visibilityOptions.count > 0 {
                visibilityTextField.text = self.addproductViewModel.visibilityOptions[row].label
                visiblityValue = self.addproductViewModel.visibilityOptions[row].value
            }else{
                visibilityTextField.text = ""
                visiblityValue = ""
            }
        }else if(pickerView.tag == 5000){
            taxClassesField.text = self.taxableOptionData[row] as? String
            if row == 0{
                taxClassesValue = "0"
            }else{
                taxClassesValue = addproductViewModel.taxOptions[row-1].value
            }
        }
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        var isValid:Int = 1;
        var errorMessge:String = GlobalData.sharedInstance.language(key: "pleaseselect")
        
        
        if productNametextField.text == ""{
            isValid = 0;
            errorMessge = errorMessge+" "+"Product Name";
        }else if descriptionField.text == ""{
            isValid = 0;
            errorMessge = errorMessge+" "+"Description";
        }else if stockTextField.text == ""{
            isValid = 0;
            errorMessge = errorMessge+" "+"Stock";
        }else if addproductViewModel.extraAddProductData.skutype == "static" && skuTextField.text == ""{
            isValid = 0;
            errorMessge = errorMessge+" "+"SKU";
        }else if pricetextField.text == ""{
            isValid = 0;
            errorMessge = errorMessge+" "+"Price";
        }else if isWeight == "1" && weightField.text == ""{
            isValid = 0;
            errorMessge = errorMessge+" "+"weight";
        }
        
        if isValid == 0{
            GlobalData.sharedInstance.showWarningSnackBar(msg: errorMessge)
        }else{
            whichApiToprocess = "saveproduct"
            callingHttppApi()
        }
    }
    
    
    func saveProfileData(fileName:String){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.showLoader()
            Alamofire.upload(multipartFormData: { multipartFormData in
                let customerId = defaults.object(forKey:"customerId");
                var params = [String:AnyObject]();
                
                params["customerToken"] = customerId as AnyObject
                
                for (key, value) in params {
                    if let data = value.data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                if self.imageData != nil{
                    let imageData1 = self.imageData! as Data
                    multipartFormData.append(imageData1, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
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
                                                self.productImageGalleryDict[fileName] = dict["file"].stringValue
                                                
                                            case .failure(let responseError):
                                                GlobalData.sharedInstance.showErrorSnackBar(msg: "Not updated")
                                                GlobalData.sharedInstance.dismissLoader()
                                                print("responseError: \(responseError)")
                                            }
                                    }
                                case .failure(let encodingError):
                                    GlobalData.sharedInstance.dismissLoader()
                                    print("encodingError: \(encodingError)")
                                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "selectCategorySegue") {
            let viewController:CategorySubcategoryController = segue.destination as UIViewController as! CategorySubcategoryController
            if assignedCategories   {
                viewController.assignedCategories = self.assignedCategoriesFromServer
                viewController.fromAssignedCategories = true
            }else{
                viewController.fromAssignedCategories = false
                viewController.categorySectionData =  self.categorySectionName
                viewController.categorySectionChildData = self.categorySectionChildArray
                viewController.categorySectionID = self.categorySectionId
                viewController.categorySectionChildID = self.categorySectionChildId;
                viewController.selectedCategoryIds = GlobalVariables.selectedCategoryIds
            }
        }else  if (segue.identifier! == "selectCategorySegue") {
            let viewController:AddRelatedProductController = segue.destination as UIViewController as! AddRelatedProductController
            viewController.productId = self.productId
            
        }else  if (segue.identifier! == "upsell") {
            let viewController:UpselleViewController = segue.destination as UIViewController as! UpselleViewController
            viewController.productId = self.productId
        }else  if (segue.identifier! == "crosssell") {
            let viewController:CrossSellViewController = segue.destination as UIViewController as! CrossSellViewController
            viewController.productId = self.productId
        }else  if (segue.identifier! == "relatedproduct") {
            let viewController:AddRelatedProductController = segue.destination as UIViewController as! AddRelatedProductController
            viewController.productId = self.productId
        }
    }
}


extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

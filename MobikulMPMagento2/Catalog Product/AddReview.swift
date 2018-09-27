//
//  AddReview.swift
//  DummySwift
//
//  Created by kunal prasad on 15/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class AddReview: UIViewController {
    
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    public var productId:String!
    public var productName:String!
    var reviewJsonData:JSON!
    var ratingsDict = [String:String]();
    let defaults = UserDefaults.standard;
    var whichapiDataToProcess:String!
    var ratingFormData:Array<JSON>!
    var keyBoardFlag:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "addreview")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddReview.dismissKeyboard))
        view.addGestureRecognizer(tap)
        whichapiDataToProcess = "";
        self.doFurtherProcessingWithResult()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        
        let storeId = defaults.object(forKey:"storeId");
        let customerId = defaults.object(forKey:"customerId");
        if storeId != nil{
            requstParams["storeId"] = storeId
        }
        GlobalData.sharedInstance.showLoader()
        let textArea:UITextView = mainView.viewWithTag(1000)! as! UITextView
        let summaryField:UITextField =   mainView.viewWithTag(2000)! as! UITextField
        let nickNameField:UITextField = mainView.viewWithTag(3000)! as! UITextField
        requstParams["productId"] = self.productId
        requstParams["title"] = summaryField.text
        requstParams["detail"] = textArea.text
        requstParams["nickname"] = nickNameField.text
        do {
            let jsonData =  try JSONSerialization.data(withJSONObject: ratingsDict, options: .prettyPrinted)
            let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["ratings"] = jsonString
        }
        catch {
            print(error.localizedDescription)
        }
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/saveReview", currentView: self){success,responseObject in
            if success == 1{
                
                print(responseObject)
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true;
                let data = responseObject as! NSDictionary
                GlobalData.sharedInstance.showSuccessMessageWithBack(view: self,message:data.object(forKey: "message") as! String )
                self.view.endEditing(true)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            var mainContainerY:CGFloat = 10
            
            let addReviewHeadingAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(16))!]
            let addReviewHeadingStringSize = GlobalData.sharedInstance.language(key:"howdoyouratethisproduct").size(withAttributes: addReviewHeadingAttributes)
            let addReviewHeadingWidth: CGFloat = addReviewHeadingStringSize.width
            let addReviewHeading = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(mainContainerY), width: addReviewHeadingWidth, height: CGFloat(25)))
            addReviewHeading.textColor = UIColor().HexToColor(hexString: "268ED7")
            addReviewHeading.font = UIFont(name: REGULARFONT, size: CGFloat(16))!
            addReviewHeading.text = GlobalData.sharedInstance.language(key:"howdoyouratethisproduct")
            addReviewHeading.backgroundColor = UIColor.clear
            self.mainView.addSubview(addReviewHeading)
            mainContainerY += 30
            
            let hr3 = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(mainContainerY), width: CGFloat(self.mainView.frame.size.width - 10), height: CGFloat(1)))
            hr3.backgroundColor = UIColor().HexToColor(hexString: "C8C4C4")
            self.mainView.addSubview(hr3)
            mainContainerY += 6
            
            if self.ratingFormData.count > 0 {
                
                for i in 0..<self.ratingFormData.count {
                    var ratingDict = self.ratingFormData[i]
                    let ratingCode = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: CGFloat(200), height: CGFloat(25)))
                    ratingCode.textColor = UIColor().HexToColor(hexString: "555555")
                    ratingCode.tag = i + 50
                    ratingCode.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    ratingCode.text = ratingDict["name"].string
                    self.mainView.addSubview(ratingCode)
                    
                    self.ratingsDict[ratingDict["id"].string!] = "0";
                    mainContainerY += 30;
                    
                    let starRatingView = HCSStarRatingView(frame: CGRect(x: 10, y: mainContainerY, width: SCREEN_WIDTH - 50 , height: 24))
                    starRatingView.maximumValue = 5
                    starRatingView.minimumValue = 0
                    starRatingView.allowsHalfStars = false
                    starRatingView.value = 0
                    starRatingView.isUserInteractionEnabled = true;
                    starRatingView.tag = i
                    starRatingView.tintColor = UIColor.black.withAlphaComponent(0.5)
                    starRatingView.addTarget(self, action: #selector(self.didChangeValue1), for: .valueChanged)
                    self.mainView.addSubview(starRatingView);
                    mainContainerY += 30;
                }
            }
            
            mainContainerY += 6
            var requiredStar: UILabel!
            let reviewDetailAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
            let reviewDetailStringSize = GlobalData.sharedInstance.language(key:"letusknowyourthought").size(withAttributes: reviewDetailAttributes)
            let reviewDetailWidth: CGFloat = reviewDetailStringSize.width
            let reviewDetailLabel = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: reviewDetailWidth, height: CGFloat(25)))
            reviewDetailLabel.textColor = UIColor().HexToColor(hexString: "555555")
            reviewDetailLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            reviewDetailLabel.text = GlobalData.sharedInstance.language(key:"letusknowyourthought")
            reviewDetailLabel.backgroundColor = UIColor.clear
            self.mainView.addSubview(reviewDetailLabel)
            requiredStar = UILabel(frame: CGRect(x: CGFloat(reviewDetailWidth + 10), y: CGFloat(mainContainerY), width: CGFloat(10), height: CGFloat(25)))
            requiredStar.text = "*"
            requiredStar.textColor =  UIColor.red
            self.mainView.addSubview(requiredStar)
            
            mainContainerY += 30
            let textArea = UITextView(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: CGFloat(self.mainView.frame.size.width - 20), height: CGFloat(200)))
            let textViewInsets = UIEdgeInsetsMake(3, 3, 3, 3)
            textArea.contentInset = textViewInsets
            textArea.tag = 1000
            textArea.layer.cornerRadius = 4
            textArea.scrollIndicatorInsets = textViewInsets
            textArea.font = UIFont.systemFont(ofSize: CGFloat(19.0))
            textArea.isScrollEnabled = true
            textArea.layer.borderColor = UIColor().HexToColor(hexString: "EEEEEE").cgColor
            textArea.layer.borderWidth = 1.0
            textArea.isEditable = true
            self.mainView.addSubview(textArea)
            
            mainContainerY += 205
            let reviewSummaryAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
            let reviewSummaryStringSize = GlobalData.sharedInstance.language(key:"summaryyourreview").size(withAttributes: reviewSummaryAttributes)
            let reviewSummaryWidth: CGFloat = reviewSummaryStringSize.width
            let reviewSummaryLabel = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: reviewSummaryWidth, height: CGFloat(25)))
            reviewSummaryLabel.textColor =  UIColor().HexToColor(hexString: "555555")
            reviewSummaryLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            reviewSummaryLabel.text = GlobalData.sharedInstance.language(key:"summaryyourreview")
            reviewSummaryLabel.backgroundColor = UIColor.clear
            self.mainView.addSubview(reviewSummaryLabel)
            requiredStar = UILabel(frame: CGRect(x: CGFloat(reviewSummaryWidth + 10), y: CGFloat(mainContainerY), width: CGFloat(10), height: CGFloat(25)))
            requiredStar.text = "*"
            requiredStar.textColor = UIColor.red
            self.mainView.addSubview(requiredStar)
            
            mainContainerY += 30
            let summaryField = UITextField(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: CGFloat(self.mainView.frame.size.width - 20), height: CGFloat(40)))
            summaryField.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            summaryField.tag = 2000
            summaryField.textColor = UIColor.black
            summaryField.textAlignment = .left
            summaryField.borderStyle = .roundedRect
            self.mainView.addSubview(summaryField)
            
            mainContainerY += 45
            let nickNameAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
            let nickNameStringSize = GlobalData.sharedInstance.language(key:"whatsyournickname").size(withAttributes: nickNameAttributes)
            let nickNameWidth: CGFloat = nickNameStringSize.width
            let nickNameLabel = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: nickNameWidth, height: CGFloat(25)))
            nickNameLabel.textColor = UIColor().HexToColor(hexString: "555555")
            nickNameLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            nickNameLabel.text = GlobalData.sharedInstance.language(key:"whatsyournickname")
            nickNameLabel.backgroundColor = UIColor.clear
            self.mainView.addSubview(nickNameLabel)
            requiredStar = UILabel(frame: CGRect(x: CGFloat(nickNameWidth + 10), y: CGFloat(mainContainerY), width: CGFloat(10), height: CGFloat(25)))
            requiredStar.text = "*"
            requiredStar.textColor = UIColor.red
            self.mainView.addSubview(requiredStar)
            
            
            mainContainerY += 30
            let nickNameField = UITextField(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: CGFloat(self.mainView.frame.size.width - 20), height: CGFloat(40)))
            nickNameField.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            nickNameField.tag = 3000
            let customerId = self.defaults.object(forKey:"customerId" )
            if customerId != nil {
                nickNameField.text = self.defaults.object(forKey:"customerName" ) as! String?
            }
            nickNameField.textColor = UIColor.black
            nickNameField.textAlignment = .left
            nickNameField.borderStyle = .roundedRect
            self.mainView.addSubview(nickNameField)
            mainContainerY += 65
            
            let submitReviewButton = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(mainContainerY), width: CGFloat(self.mainView.frame.size.width - 20), height: CGFloat(50)))
            submitReviewButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            submitReviewButton.textColor = UIColor.white
            submitReviewButton.text = GlobalData.sharedInstance.language(key: "submitreview")
            submitReviewButton.isUserInteractionEnabled = true
            submitReviewButton.textAlignment = .center
            submitReviewButton.layer.cornerRadius = 5
            submitReviewButton.layer.masksToBounds = true
            self.mainView.addSubview(submitReviewButton)
            let addToCartGesture = UITapGestureRecognizer(target: self, action: #selector(self.submitReview))
            addToCartGesture.numberOfTapsRequired = 1
            submitReviewButton.addGestureRecognizer(addToCartGesture)
            mainContainerY += 70
            
            self.mainViewHeightConstarints.constant = mainContainerY + 80;
        }
    }
    
    @objc func didChangeValue1(_ sender: HCSStarRatingView) {
        var ratingDict = ratingFormData[sender.tag];
        let values:String = (ratingDict["values"][Int(sender.value) - 1]).string!
        ratingsDict[ratingDict["id"].string!] = values
    }
    
    @objc func submitReview(_ recognizer: UITapGestureRecognizer) {
        var isValid:Int = 1
        var errorMessages: String = " ";
        
        for i in 0..<ratingFormData.count {
            var ratingDict = ratingFormData[i]
            
            if(ratingsDict[ratingDict["id"].string!] == "0"){
                isValid = 0;
                errorMessages = GlobalData.sharedInstance.language(key:"pleaserate") + " " + ratingDict["name"].string!
            }
        }
        if(isValid == 0){
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessages)
            return
        }
        
        let textArea:UITextView = mainView.viewWithTag(1000)! as! UITextView
        let summaryField:UITextField = mainView.viewWithTag(2000)! as! UITextField
        let nickNameField:UITextField = mainView.viewWithTag(3000)! as! UITextField
        
        if textArea.text == "" {
            isValid = 0
            errorMessages = GlobalData.sharedInstance.language(key:"reviewrequired")
        }else if summaryField.text == "" {
            isValid = 0
            errorMessages = GlobalData.sharedInstance.language(key:"summaryrequired")
        }else if nickNameField.text == "" {
            isValid = 0
            errorMessages = GlobalData.sharedInstance.language(key:"nicknamerequired")
        }
        
        if(isValid == 0){
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessages)
        }
        
        if(isValid == 1){
            whichapiDataToProcess = "saveReviews"
            callingHttppApi();
        }
    }
}

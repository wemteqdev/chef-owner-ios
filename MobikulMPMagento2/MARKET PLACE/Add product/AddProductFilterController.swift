//
//  AddProductFilterController.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//





@objc protocol AddproductFilterDataHandle: class {
    func filterData(data1:NSMutableArray,data2:NSMutableArray)
    
}





import UIKit

class AddProductFilterController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{

@IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
@IBOutlet weak var mainView: UIView!
@IBOutlet weak var cancelButton: UIButton!
var mainCollection:JSON!
var optionArray:JSON = []
var filterItemkey:NSMutableArray = []
var filterItemValue:NSMutableArray = []
@IBOutlet weak var applybutton: UIButton!
var selectItemValue = [String:String]()
var delegate:AddproductFilterDataHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupview()
    }

   
    @IBAction func cancelClick(_ sender: UIButton) {
          dismiss(animated: true, completion: nil)
    }
    
    
    
    func setupview(){
        var Y:CGFloat = 5
        for i in 0..<mainCollection["filterOption"].count{
           var dict = self.mainCollection["filterOption"][i]
            
            if dict["type"].stringValue == "textRange"{
                
                let optionLbl = UILabel(frame: CGRect(x: 5, y: Y, width: self.mainView.frame.size.width - 10, height: 25))
                optionLbl.textColor = UIColor.black
                optionLbl.backgroundColor = UIColor.clear
                optionLbl.font = UIFont(name: BOLDFONT, size: 15)
                optionLbl.textAlignment = .left
                optionLbl.tag = 1;
                optionLbl.text = dict["name"].stringValue
                self.mainView.addSubview(optionLbl)
                
                Y += 30
                
                let textField = UIFloatLabelTextField(frame: CGRect(x: 5, y: Y, width: 70 , height: 50))
                textField.placeholder = "From"
                textField.borderStyle = UITextBorderStyle.roundedRect
                textField.keyboardType = UIKeyboardType.default
                textField.tag = 9000 + i;
                textField.backgroundColor = UIColor.white
                textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                textField.isUserInteractionEnabled = true
                self.mainView.addSubview(textField)
                
                let textField2 = UIFloatLabelTextField(frame: CGRect(x: 85, y: Y, width: 70 , height: 50))
                textField2.placeholder = "To"
                textField2.borderStyle = UITextBorderStyle.roundedRect
                textField2.keyboardType = UIKeyboardType.default
                textField2.tag = 7000 + i;
                textField2.backgroundColor = UIColor.white
                textField2.font = UIFont.init(name: REGULARFONT, size: 13.0)
                textField2.isUserInteractionEnabled = true
                self.mainView.addSubview(textField2)
                
                Y += 60;
                
            }
            else if dict["type"].stringValue == "text" {
                let textField = UIFloatLabelTextField(frame: CGRect(x: 5, y: Y, width: self.mainView.frame.size.width - 10, height: 50))
                textField.placeholder = dict["name"].stringValue
                textField.borderStyle = UITextBorderStyle.roundedRect
                textField.keyboardType = UIKeyboardType.decimalPad
                textField.tag = 9000 + i;
                textField.backgroundColor = UIColor.white
                textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                textField.isUserInteractionEnabled = true
                self.mainView.addSubview(textField)
                Y += 60;
                
            }
            else if dict["type"].stringValue == "select" {
                let textField = UIFloatLabelTextField(frame: CGRect(x: 5, y: Y, width: self.mainView.frame.size.width - 10, height: 50))
                textField.placeholder = dict["name"].stringValue
                textField.borderStyle = UITextBorderStyle.roundedRect
                textField.keyboardType = UIKeyboardType.default
                textField.tag = 10000 + i;
                textField.addTarget(self, action: #selector(self.selectAttributeText), for: UIControlEvents.editingDidBegin)
                textField.backgroundColor = UIColor.white
                textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                textField.isUserInteractionEnabled = true
                self.mainView.addSubview(textField)
                selectItemValue[dict["id"].stringValue] = ""
                Y += 60;
                
            }
            
            
            
        }
        
        mainViewHeightConstarints.constant = Y + 50;
        
    }
    
    
    
    
    
    @objc func selectAttributeText(textField: UITextField) {
          var dict = self.mainCollection["filterOption"][textField.tag - 10000];
          optionArray = dict["options"]
          let thePicker = UIPickerView()
          thePicker.tag = textField.tag
          textField.inputView = thePicker
          thePicker.delegate = self
    
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dict = optionArray[row];
        return dict["label"].stringValue
    
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let dict = optionArray[row];
        let requiredtextField = self.mainView.viewWithTag(pickerView.tag) as! UITextField
        requiredtextField.text = dict["label"].stringValue
        var mainDict = self.mainCollection["filterOption"][pickerView.tag - 10000];
        selectItemValue[mainDict["id"].stringValue] = dict["value"].stringValue
    
    }
    
    
    @IBAction func applyClick(_ sender: UIButton) {
        filterItemkey = []
        filterItemValue = []
        
        for i in 0..<mainCollection["filterOption"].count{
            var dict = self.mainCollection["filterOption"][i]
            
            
            if dict["type"].stringValue == "textRange"{
               let textField1 = self.mainView.viewWithTag(9000+i) as! UITextField
                let textField2 = self.mainView.viewWithTag(7000+i) as! UITextField
                filterItemValue.add(textField1.text!+"-"+textField2.text!)
                filterItemkey.add(dict["id"].stringValue)
                
            }else if dict["type"].stringValue == "text"{
                let textField1 = self.mainView.viewWithTag(9000+i) as! UITextField
                filterItemValue.add(textField1.text!)
                filterItemkey.add(dict["id"].stringValue)
                
            }else if dict["type"].stringValue == "select"{
                filterItemValue.add(selectItemValue[dict["id"].stringValue])
                filterItemkey.add(dict["id"].stringValue)
                
            }
            
        
        
        }
         dismiss(animated: true, completion: nil)
        delegate.filterData(data1: filterItemkey, data2: filterItemValue)
        
        
        
    }
    
    
}

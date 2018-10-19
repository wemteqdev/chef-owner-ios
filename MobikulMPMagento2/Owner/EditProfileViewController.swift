//
//  EditProfileViewController.swift
//  Chef-Supplier
//
//  Created by andonina on 10/14/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
//
//  MyProductListFilterController.swift
//  ShangMarket
//
//  Created by kunal on 28/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

@objc protocol EditProfiledelegate: class {
    func saveData(data:String, id: Int)
    func saveProfileImage()
    func saveProfile()
}

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dataField: SkyFloatingLabelTextField!
    var delegate:EditProfiledelegate!
    var data:String = "";
    var placeholdString:String = "";
    var id = -1;
    var countryData = [CountryData]();
    var currentCountryRow = 0;
    var dataType = 0;
    var countryId = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitle(GlobalData.sharedInstance.language(key: "save"), for: .normal)
        saveButton.layer.cornerRadius = 5;
        saveButton.layer.masksToBounds = true;
        dataField.text = data;
        dataField.placeholder = placeholdString;
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate.saveData(data: self.dataField.text!, id: self.id)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.countryData.count;
        }
        else if(pickerView.tag == 2000){
            return self.countryData[currentCountryRow].stateData.count
        }
        else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            return self.countryData[row].name
        }
        else  if pickerView.tag == 2000{
            return self.countryData[currentCountryRow].stateData[row].name
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            self.dataField.text =  self.countryData[row].name;
            self.countryId = self.countryData[row].countryId
            currentCountryRow = row
        }else if pickerView.tag == 2000{
            self.dataField.text = self.countryData[currentCountryRow].stateData[row].name;
            self.countryId = self.countryData[currentCountryRow].stateData[row].regionId;
        }        
    }
    
    @IBAction func countryClick(_ sender: UITextField) {
        if(dataType != 0){
            let thePicker = UIPickerView()
            if(dataType == 1){
                thePicker.tag = 1000;
            } else {
                thePicker.tag = 2000;
            }
            dataField.inputView = thePicker
            thePicker.delegate = self
        }
    }
}

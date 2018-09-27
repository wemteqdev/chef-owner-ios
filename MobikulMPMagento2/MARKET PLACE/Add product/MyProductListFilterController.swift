//
//  MyProductListFilterController.swift
//  ShangMarket
//
//  Created by kunal on 28/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

@objc protocol MyProductListFilerdelegate: class {
    func myProductFilterData(name:String,fromDate:String,toDate:String,status:String)
}

class MyProductListFilterController: UIViewController {
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearbutton: UIButton!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var statusTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nametextFeild: SkyFloatingLabelTextField!
    @IBOutlet weak var toDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fromDateTextField: SkyFloatingLabelTextField!
    var delegate:MyProductListFilerdelegate!
    
    var disabledStatusText: String = ""
    var enabledStatusText: String = ""
    var selectedStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyButton.setTitle(GlobalData.sharedInstance.language(key: "apply"), for: .normal)
        clearbutton.setTitle(GlobalData.sharedInstance.language(key: "clearall"), for: .normal)
        applyButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        clearbutton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        statusTextField.placeholder = GlobalData.sharedInstance.language(key: "status")
        nametextFeild.placeholder = GlobalData.sharedInstance.language(key: "name")
        toDateTextField.placeholder = GlobalData.sharedInstance.language(key: "todate")
        fromDateTextField.placeholder = GlobalData.sharedInstance.language(key: "fromdate")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearClick(_ sender: UIButton) {
        statusTextField.text = ""
        nametextFeild.text = ""
        toDateTextField.text = ""
        fromDateTextField.text = ""
    }
    
    @IBAction func applyClick(_ sender: UIButton) {
        
        delegate.myProductFilterData( name: nametextFeild.text!, fromDate: fromDateTextField.text!, toDate: toDateTextField.text!, status: selectedStatus)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toDateClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(MyProductListFilterController.datePickerToValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func fromDateClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        fromDateTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(MyProductListFilterController.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        fromDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func statusSelectionBtnClick(_ sender: UIButton)  {
        self.view.endEditing(true)
        
        var arr : [String] = [String]()
        arr.append("All")
        arr.append(enabledStatusText)
        arr.append(disabledStatusText)
        UIBarButtonItem.appearance().tintColor = UIColor.black
        ActionSheetStringPicker.show(withTitle: "", rows: arr, initialSelection: 0, doneBlock: {
            picker, indexes, values in
            
            print("values = \(String(describing: values))")
            print("indexes = \(indexes)")
            print("picker = \(String(describing: picker))")
            
            if indexes == 0 {
                self.selectedStatus = ""
                self.statusTextField.text = GlobalData.sharedInstance.language(key: "All")
            }else if indexes == 1 {
                self.selectedStatus = "1"
                self.statusTextField.text = self.enabledStatusText
            }else {
                self.selectedStatus = "2"
                self.statusTextField.text = self.disabledStatusText
            }
            
            UIBarButtonItem.appearance().tintColor = UIColor.white
            return
        }, cancel: { ActionMultipleStringCancelBlock in
            UIBarButtonItem.appearance().tintColor = UIColor.white
            return }, origin: sender)
    }
}

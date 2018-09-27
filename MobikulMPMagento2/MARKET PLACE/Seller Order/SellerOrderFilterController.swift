//
//  SellerOrderFilterController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerOrderFilterController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
@IBOutlet weak var resetButton: UIButton!
@IBOutlet weak var filterLabel: UILabel!
@IBOutlet weak var orderIdTextField: SkyFloatingLabelTextField!
@IBOutlet weak var selectDateLabel: UILabel!
@IBOutlet weak var fromDateTextField: SkyFloatingLabelTextField!
@IBOutlet weak var toDateTextField: SkyFloatingLabelTextField!
@IBOutlet weak var orderStatusTextField: SkyFloatingLabelTextField!
@IBOutlet weak var ApplyButton: UIButton!
var sellerOrderViewModel:SellerOrderViewModel!
var status:String = ""
var delegate: SellerOrderFilterDataHandle!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.setTitle(GlobalData.sharedInstance.language(key: "reset"), for: .normal)
        ApplyButton.setTitle(GlobalData.sharedInstance.language(key: "apply"), for: .normal)
        ApplyButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        filterLabel.text = GlobalData.sharedInstance.language(key: "filter")
        selectDateLabel.text = GlobalData.sharedInstance.language(key: "selectdate")
        orderIdTextField.placeholder = GlobalData.sharedInstance.language(key: "enterorderid")
        fromDateTextField.placeholder = GlobalData.sharedInstance.language(key: "fromdate")
        toDateTextField.placeholder = GlobalData.sharedInstance.language(key: "todate")
        orderStatusTextField.placeholder = GlobalData.sharedInstance.language(key: "orderstatus")
        if sellerOrderViewModel.orderStatus.count > 0{
            orderStatusTextField.text = sellerOrderViewModel.orderStatus[0].label
            status = sellerOrderViewModel.orderStatus[0].status
        }
        
        
        
        
     }
    
    
    
    @IBAction func dismissController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func fromDateClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.tag = 1001
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        fromDateTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SellerOrderFilterController.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        if sender.tag == 1001   {
            fromDateTextField.text = dateFormatter.string(from: sender.date)
        }else{
            toDateTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @IBAction func toDateClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.tag = 1002
        datePickerView.datePickerMode = UIDatePickerMode.date
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SellerOrderFilterController.datePickerToValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    @IBAction func orderStatusClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        orderStatusTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.sellerOrderViewModel.orderStatus.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.sellerOrderViewModel.orderStatus[row].label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            self.orderStatusTextField.text =  self.sellerOrderViewModel.orderStatus[row].label
        
    }
    
    
    @IBAction func applyClick(_ sender: UIButton) {
        delegate.sellerOrderFilterData(data: true, orderid: orderIdTextField.text!, fromDate: fromDateTextField.text!, toDate: toDateTextField.text!, status: status)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    

  
}

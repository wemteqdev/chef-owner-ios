//
//  MyTransactionFilterController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class MyTransactionFilterController: UIViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var orderIdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var fromDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var toDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var ApplyButton: UIButton!
    var delegate:SellerTransactionFilterDataHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.setTitle(GlobalData.sharedInstance.language(key: "reset"), for: .normal)
        ApplyButton.setTitle(GlobalData.sharedInstance.language(key: "apply"), for: .normal)
        ApplyButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        filterLabel.text = GlobalData.sharedInstance.language(key: "filter")
        selectDateLabel.text = GlobalData.sharedInstance.language(key: "selectdate")
        orderIdTextField.placeholder = GlobalData.sharedInstance.language(key: "entertransactionid")
        fromDateTextField.placeholder = GlobalData.sharedInstance.language(key: "fromdate")
        toDateTextField.placeholder = GlobalData.sharedInstance.language(key: "todate")
        
        
    }
    
    
    
    
    
    
    @IBAction func dismissController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fromDateClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
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
        fromDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func toDateClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(SellerOrderFilterController.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    @IBAction func applyClick(_ sender: UIButton) {
        delegate.sellerTransactionFilterData(data: true, orderid: orderIdTextField.text!, fromDate: fromDateTextField.text!, toDate: toDateTextField.text!)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}

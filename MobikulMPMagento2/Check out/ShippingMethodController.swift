//
//  ShippingMethodController.swift
//  Magento2V4Theme
//
//  Created by kunal on 20/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ShippingMethodController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
@IBOutlet weak var addressImageView: UIImageView!
@IBOutlet weak var addressLabel: UILabel!
@IBOutlet weak var shipmentImageView: UIImageView!
@IBOutlet weak var shippingLabel: UILabel!
@IBOutlet weak var paymentImageView: UIImageView!
@IBOutlet weak var paymentLabel: UILabel!
@IBOutlet weak var summaryImageView: UIImageView!
@IBOutlet weak var summaryLabel: UILabel!
    
    
    
    
@IBOutlet weak var shippingtableView: UITableView!
@IBOutlet weak var continueButton: UIButton!
var shipmentPaymentMethodViewModel:ShipmentAndPaymentViewModel!
var shippingId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addressImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addressImageView.layer.cornerRadius = 15;
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        shipmentImageView.layer.cornerRadius = 15;
        shipmentImageView.layer.masksToBounds = true
        
        paymentImageView.layer.cornerRadius = 15;
        paymentImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 15;
        summaryImageView.layer.masksToBounds = true
        
        
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitle(GlobalData.sharedInstance.language(key: "continue"), for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        shippingtableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        shippingtableView.rowHeight = UITableViewAutomaticDimension
        self.shippingtableView.estimatedRowHeight = 50
        shippingtableView.separatorColor = UIColor.clear
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = billingNavigationController as! UINavigationController;
        let billingViewController = nav.viewControllers[0] as! ShippingAddressViewController
        self.shipmentPaymentMethodViewModel = billingViewController.shipmentPaymentMethodViewModel
        if GlobalVariables.CurrentIndex == 2{
        self.shippingtableView.dataSource = self
        self.shippingtableView.delegate = self
        }
    }
    
    
    @IBAction func goToshippingAddress(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
          return self.shipmentPaymentMethodViewModel.shipmentData.count
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return self.shipmentPaymentMethodViewModel.shipmentData[section].shipmentContentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].label+" "+self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].price
        
        if shippingId == self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].code{
            cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return self.shipmentPaymentMethodViewModel.shipmentData[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       shippingId = self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].code
       self.shippingtableView.reloadData()
    }
    
    
    
    
    
    @IBAction func continueClick(_ sender: Any) {
        if shippingId == ""{
            GlobalData.sharedInstance.showErrorSnackBar(msg: "Please select shipping Method")
        }else {
            GlobalVariables.CurrentIndex = 3
            self.tabBarController!.selectedIndex = 2
        }
    }
    
}

//
//  OrderPlaced.swift
//  Mobikul
//
//  Created by kunal prasad on 14/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class OrderPlaced: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainHeading: UILabel!
    @IBOutlet weak var thankforyourpurchase: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderContinueButton: UIButton!
    public var incrementId:String!
    public var bottomButton :Int!
    
    @IBOutlet weak var confirmmessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.title = GlobalData.sharedInstance.language(key:"orderplaced")
        
        orderLabel.text = GlobalData.sharedInstance.language(key: "orderid")+incrementId;
        orderContinueButton.setTitle(GlobalData.sharedInstance.language(key:"continue"), for: .normal)
        orderContinueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR);
        mainHeading.text = GlobalData.sharedInstance.language(key:"orderreceived")
        thankforyourpurchase.text = GlobalData.sharedInstance.language(key:"thankuforpurchase")
        confirmmessageLabel.text = GlobalData.sharedInstance.language (key:"confirmationmessage")
        orderContinueButton.layer.cornerRadius = 5
        orderContinueButton.clipsToBounds = true
        
        let openOrderDetailsGesture = UITapGestureRecognizer(target: self, action: #selector(self.orderDetails))
        openOrderDetailsGesture.numberOfTapsRequired = 1
        orderLabel.addGestureRecognizer(openOrderDetailsGesture)
        UserDefaults.standard.removeObject(forKey: "quoteId")
        UserDefaults.standard.synchronize()
        
    }
    
    @IBAction func continueOrder(_ sender: Any) {
        GlobalVariables.proceedToCheckOut = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func orderDetails(_ recognizer: UITapGestureRecognizer) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "customerorderdetails") as! CustomerOrderDetails
        vc.incrementId = incrementId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
